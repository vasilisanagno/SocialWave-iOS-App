import Foundation
import KeychainSwift

//view model that keeps the variable state across multiple views, makes logout and delete account
//and communicates with the server to retrieve friends/requests, to delete a post,
//to send or unsend a request to someone and go back to the search view after searching in others profile
@MainActor
class ProfileViewModel: ObservableObject {
    private let repository: AuthRepository
    private let userRepository: UserRepository
    private let postRepository: PostRepository
    private let sharedViewModel: SharedViewModel
    private let socketViewModel: SocketViewModel
    @Published var backButtonClicked = false
    @Published var clickedPostIndex: Int = 0
    @Published var postClicked: Bool = false
    @Published var selectedIndex: Int = 0
    @Published var addFriendClicked = false
    @Published var processOnBoard = false
    
    init(repository: AuthRepository = DIContainer.shared.container.resolve(AuthRepository.self)!,
         userRepository: UserRepository = DIContainer.shared.container.resolve(UserRepository.self)!,
         postRepository: PostRepository = DIContainer.shared.container.resolve(PostRepository.self)!,
         sharedViewModel: SharedViewModel = DIContainer.shared.container.resolve(SharedViewModel.self)!,
         socketViewModel: SocketViewModel = DIContainer.shared.container.resolve(SocketViewModel.self)!) {
        self.repository = repository
        self.userRepository = userRepository
        self.postRepository = postRepository
        self.sharedViewModel = sharedViewModel
        self.socketViewModel = socketViewModel
    }
    
    func logOut() {
        let keychain = KeychainSwift()
        keychain.delete("jwt")
        sharedViewModel.password = ""
        sharedViewModel.email = ""
        sharedViewModel.startPath.removeAll()
        for i in 0..<5 {
            sharedViewModel.tabPath[i].removeAll()
        }
        sharedViewModel.showSettings = false
        sharedViewModel.selectedTab = 1
        sharedViewModel.profileUserListFromSearchTab = []
        sharedViewModel.profileUserListFromProfileTab = []
        
        sharedViewModel.searchUser = UserDetails()
        
        sharedViewModel.users = [UserDetails]()
        
        sharedViewModel.friendsOriginalFromSearchTab = []
        sharedViewModel.friendsOriginalFromProfileTab = []
        
        sharedViewModel.filteredFriendsFromSearchTab = []
        sharedViewModel.filteredFriendsFromProfileTab = []
        
        sharedViewModel.friendsListPathFromSearchTab = []
        sharedViewModel.friendsListPathFromProfileTab = []
         
        sharedViewModel.friendsLikedPost = []
        
        sharedViewModel.searchTextFromSearchTab = ""
        sharedViewModel.searchTextFromProfileTab = ""
        
        sharedViewModel.searchTextListFromSearchTab = []
        sharedViewModel.searchTextListFromProfileTab = []
        sharedViewModel.numOfClicksOnUsersFromSearchTab = 0
        sharedViewModel.numOfClicksOnUsersFromProfileTab = 0
        sharedViewModel.loginSuccess = false
        sharedViewModel.autoLogin = false
    }
    
    func deleteUser() {
        Task {
            try await deleteAccount()
            logOut()
        }
    }
    
    private func deleteAccount() async throws {
        do {
            try await repository.deleteUser(
                token: KeychainSwift().get("jwt") ?? ""
            )
        } catch {
            print(error)
            if error.asAFError?.responseCode == 401 {
                sharedViewModel.unauthorizedAccess()
            }
        }
    }
    
    func findFriends() {
        Task {
            await retrieveFriendsOfUser()
            sharedViewModel.friendsOrRequests = false
            if sharedViewModel.selectedTab == 2 {
                sharedViewModel.searchTextFromSearchTab = ""
                sharedViewModel.tabPath[1].append("Search Friends")
            }
            else {
                sharedViewModel.searchTextFromProfileTab = ""
                sharedViewModel.tabPath[4].append("Search Friends")
            }
        }
    }
    
    private func retrieveFriendsOfUser() async {
        do {
            let friends = try await userRepository.getFriendsData(token: KeychainSwift().get("jwt") ?? "",username: sharedViewModel.profileUser.username)
            if sharedViewModel.selectedTab == 2 {
                sharedViewModel.friendsOriginalFromSearchTab = friends
                sharedViewModel.filteredFriendsFromSearchTab = friends
                sharedViewModel.friendsListPathFromSearchTab.append(friends)
            }
            else {
                sharedViewModel.friendsOriginalFromProfileTab = friends
                sharedViewModel.filteredFriendsFromProfileTab = friends
                sharedViewModel.friendsListPathFromProfileTab.append(friends)
            }
        } catch {
            print(error)
            if error.asAFError?.responseCode == 401 {
                sharedViewModel.unauthorizedAccess()
            }
        }
    }
    
    func findRequests() {
        Task {
            await retrieveRequestsOfUser()
            sharedViewModel.friendsOrRequests = true
            sharedViewModel.searchTextFromProfileTab = ""
            sharedViewModel.tabPath[4].append("Search Friends")
        }
    }
    
    private func retrieveRequestsOfUser() async {
        do {
            let requests = try await userRepository.getFriendRequests(token: KeychainSwift().get("jwt") ?? "")
            sharedViewModel.friendsOriginalFromProfileTab = requests
            sharedViewModel.filteredFriendsFromProfileTab = requests
            sharedViewModel.friendsListPathFromProfileTab.append(requests)
        } catch {
            print(error)
            if error.asAFError?.responseCode == 401 {
                sharedViewModel.unauthorizedAccess()
            }
        }
    }
    
    func sendOrUnsendRequest() {
        Task {
            await sendOrUnsendRequestToAUser()
        }
    }
    
    private func sendOrUnsendRequestToAUser() async {
        do {
            processOnBoard = true
            if sharedViewModel.selectedTab == 2 {
                sharedViewModel.pendingOrNotFromSearchTab.toggle()
            }
            else if sharedViewModel.selectedTab == 5 {
                sharedViewModel.pendingOrNotFromProfileTab.toggle()
            }
            sharedViewModel.currentUser.sending = ((sharedViewModel.selectedTab == 2 && sharedViewModel.pendingOrNotFromSearchTab)||(sharedViewModel.selectedTab == 5 && sharedViewModel.pendingOrNotFromProfileTab)||(sharedViewModel.selectedTab == 1 && sharedViewModel.suggestedFriend.pendingOrNot!)) ? try await userRepository.willingToMakeNewFriend(token: KeychainSwift().get("jwt") ?? "", senderId: sharedViewModel.currentUser.id, receiverId: sharedViewModel.selectedTab == 1 ? sharedViewModel.suggestedFriend.id : sharedViewModel.profileUser.id) :
            try await userRepository.notWillingToMakeNewFriend(token: KeychainSwift().get("jwt") ?? "", senderId: sharedViewModel.currentUser.id, receiverId:sharedViewModel.selectedTab == 1 ? sharedViewModel.suggestedFriend.id : sharedViewModel.profileUser.id)
            if (sharedViewModel.selectedTab == 2 && sharedViewModel.pendingOrNotFromSearchTab)||(sharedViewModel.selectedTab == 5 && sharedViewModel.pendingOrNotFromProfileTab)||(sharedViewModel.selectedTab == 1 && sharedViewModel.suggestedFriend.pendingOrNot!) {
                socketViewModel.sendNotification(sender: sharedViewModel.currentUser.username, receiver: sharedViewModel.selectedTab == 1 ? sharedViewModel.suggestedFriend.username : sharedViewModel.profileUser.username)
            }
            processOnBoard = false
        } catch {
            print(error)
            if error.asAFError?.responseCode == 401 {
                sharedViewModel.unauthorizedAccess()
            }
        }
    }
    
    func getBackButtonDetails() {
        if !backButtonClicked {
            backButtonClicked = true
            if sharedViewModel.selectedTab == 2 {
                sharedViewModel.numOfClicksOnUsersFromSearchTab-=1
                sharedViewModel.profileUserListFromSearchTab.removeLast()
                
                if sharedViewModel.profileUserListFromSearchTab.count != 0 {
                    sharedViewModel.profileUser = sharedViewModel.profileUserListFromSearchTab.last!
                }
                else {
                    sharedViewModel.profileUser = sharedViewModel.currentUser
                }
                backButtonClicked = false
                sharedViewModel.tabPath[1].removeLast()
            }
            else {
                sharedViewModel.profileUserListFromProfileTab.removeLast()
                
                if sharedViewModel.profileUserListFromProfileTab.count != 0 {
                    sharedViewModel.profileUser = sharedViewModel.profileUserListFromProfileTab.last!
                }
                else {
                    sharedViewModel.profileUser = sharedViewModel.currentUser
                }
                backButtonClicked = false
                sharedViewModel.tabPath[4].removeLast()
            }
        }
    }
    
    //checks if the user has sent request and is pending now or not
    private func checkIfProfileUserHasPendingRequest() async throws {
        (sharedViewModel.currentUser.sending, sharedViewModel.currentUser.receiving, sharedViewModel.currentUser.friends) = try await userRepository.renewSRFDetails(token: KeychainSwift().get("jwt") ?? "")
        for i in 0..<sharedViewModel.currentUser.sending.count {
            if sharedViewModel.currentUser.sending[i] == sharedViewModel.profileUser.id {
                if sharedViewModel.selectedTab == 2 {
                    sharedViewModel.pendingOrNotFromSearchTab = true
                }
                else {
                    sharedViewModel.pendingOrNotFromProfileTab = true
                }
                break
            }
            else {
                if i == sharedViewModel.currentUser.sending.count-1 {
                    if sharedViewModel.selectedTab == 2 {
                        sharedViewModel.pendingOrNotFromSearchTab = false
                    }
                    else {
                        sharedViewModel.pendingOrNotFromProfileTab = false
                    }
                }
            }
        }
    }
    
    func reloadUserDetailsInProfileTask() {
        Task {
            try await reloadUserDetailsInProfile()
        }
    }
    
    private func reloadUserDetailsInProfile() async throws {
        do {
            sharedViewModel.showProgress = true
            (sharedViewModel.profileUser, sharedViewModel.profileUserPosts) = try await userRepository.getUserAndPostsDetails(token: KeychainSwift().get("jwt") ?? "", username: sharedViewModel.profileUser.username)
            try await checkIfProfileUserHasPendingRequest()
            sharedViewModel.checkIfProfileUserIsFriend()
            sharedViewModel.showProgress = false
        } catch {
            print(error)
            if error.asAFError?.responseCode == 401 {
                sharedViewModel.unauthorizedAccess()
            }
        }
    }
    
    func deletePost(postId: String) async throws {
        do {
            _ = try await postRepository.deletePost(
                token: KeychainSwift().get("jwt") ?? "",
                postId: postId
            )
            postClicked = false
            try await reloadUserDetailsInProfile()
        } catch {
            print(error)
            if error.asAFError?.responseCode == 401 {
                sharedViewModel.unauthorizedAccess()
            }
        }
    }
}
