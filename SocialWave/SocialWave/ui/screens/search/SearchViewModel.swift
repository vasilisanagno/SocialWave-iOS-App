import Foundation
import KeychainSwift

//view model that keeps the variable state across multiple views, filter-search users/friends
//and communicates with the server to delete a friend, to accept/reject a request and
//go back to the profile view after searching in search view
@MainActor
class SearchViewModel: ObservableObject {
    private let repository: UserRepository
    private let sharedViewModel: SharedViewModel
    @Published var isEditing = false
    @Published var backButtonClicked = false
    
    init(repository: UserRepository = DIContainer.shared.container.resolve(UserRepository.self)!,
         sharedViewModel: SharedViewModel = DIContainer.shared.container.resolve(SharedViewModel.self)!) {
        self.repository = repository
        self.sharedViewModel = sharedViewModel
    }
    
    func searchUsers() {
        Task {
            do {
                sharedViewModel.showProgress = true
                sharedViewModel.users = try await repository.searchUsers(text: sharedViewModel.selectedTab == 2 ? sharedViewModel.searchTextFromSearchTab : sharedViewModel.searchTextFromProfileTab, token: KeychainSwift().get("jwt") ?? "")
                sharedViewModel.showProgress = false
            } catch {
                print(error)
                if error.asAFError?.responseCode == 401 {
                    sharedViewModel.unauthorizedAccess()
                }
            }
        }
    }
    
    func filterFriends() -> [UserDetails] {
        if sharedViewModel.selectedTab == 2 {
            if sharedViewModel.searchTextFromSearchTab.isEmpty {
                return sharedViewModel.friendsOriginalFromSearchTab
            }
            else {
                return sharedViewModel.friendsOriginalFromSearchTab.filter { $0.username.lowercased().hasPrefix(sharedViewModel.searchTextFromSearchTab.lowercased()) }
            }
        }
        else {
            if sharedViewModel.searchTextFromProfileTab.isEmpty {
                return sharedViewModel.friendsOriginalFromProfileTab
            }
            else {
                return sharedViewModel.friendsOriginalFromProfileTab.filter { $0.username.lowercased().hasPrefix(sharedViewModel.searchTextFromProfileTab.lowercased()) }
            }
        }
    }
    
    func getBackButtonDetails() {
        if !backButtonClicked {
            backButtonClicked = true
            if sharedViewModel.selectedTab == 2 {
                if sharedViewModel.numOfClicksOnUsersFromSearchTab == sharedViewModel.searchTextListFromSearchTab.count-1 {
                    if sharedViewModel.searchTextListFromSearchTab.count != 0 {
                        sharedViewModel.searchTextListFromSearchTab.removeLast()
                    }
                }
                if sharedViewModel.searchTextListFromSearchTab.count != 0 {
                    sharedViewModel.searchTextFromSearchTab = sharedViewModel.searchTextListFromSearchTab[sharedViewModel.searchTextListFromSearchTab.count-1]
                }
                
                if sharedViewModel.friendsListPathFromSearchTab.count != 0 {
                    sharedViewModel.friendsListPathFromSearchTab.removeLast()
                }
                if sharedViewModel.friendsListPathFromSearchTab.count != 0 {
                    sharedViewModel.friendsOriginalFromSearchTab = sharedViewModel.friendsListPathFromSearchTab[sharedViewModel.friendsListPathFromSearchTab.count-1]
                    sharedViewModel.filteredFriendsFromSearchTab = sharedViewModel.friendsOriginalFromSearchTab
                }
                backButtonClicked = false
                sharedViewModel.checkIfProfileUserIsFriend()
                sharedViewModel.tabPath[1].removeLast()
            }
            else {
                if sharedViewModel.searchTextListFromProfileTab.count != 0 {
                    sharedViewModel.searchTextFromProfileTab = sharedViewModel.searchTextListFromProfileTab[sharedViewModel.searchTextListFromProfileTab.count-1]
                }
                if sharedViewModel.numOfClicksOnUsersFromProfileTab == sharedViewModel.searchTextListFromProfileTab.count {
                    if sharedViewModel.searchTextListFromProfileTab.count != 0 {
                        sharedViewModel.numOfClicksOnUsersFromProfileTab-=1
                        sharedViewModel.searchTextListFromProfileTab.removeLast()
                    }
                }
                sharedViewModel.friendsListPathFromProfileTab.removeLast()
                if sharedViewModel.friendsListPathFromProfileTab.count != 0 {
                    sharedViewModel.friendsOriginalFromProfileTab = sharedViewModel.friendsListPathFromProfileTab[sharedViewModel.friendsListPathFromProfileTab.count-1]
                    sharedViewModel.filteredFriendsFromProfileTab = sharedViewModel.friendsOriginalFromProfileTab
                }
                backButtonClicked = false
                sharedViewModel.checkIfProfileUserIsFriend()
                sharedViewModel.requestScreenNow = false
                sharedViewModel.tabPath[4].removeLast()
            }
        }
    }
    
    func goToTheNextUser(user: Int) {
        sharedViewModel.searchUser = ((sharedViewModel.selectedTab == 2 && sharedViewModel.tabPath[1].last == "Search Friends") ? sharedViewModel.filteredFriendsFromSearchTab[user] : (sharedViewModel.selectedTab == 5) ? sharedViewModel.filteredFriendsFromProfileTab[user] : sharedViewModel.users[user])
        sharedViewModel.profileUser = sharedViewModel.searchUser
        if sharedViewModel.selectedTab == 2 {
            if sharedViewModel.numOfClicksOnUsersFromSearchTab < sharedViewModel.searchTextListFromSearchTab.count {
                sharedViewModel.searchTextListFromSearchTab.removeLast()
            }
            sharedViewModel.numOfClicksOnUsersFromSearchTab+=1
            sharedViewModel.searchTextListFromSearchTab.append(sharedViewModel.searchTextFromSearchTab)
            sharedViewModel.profileUserListFromSearchTab.append(sharedViewModel.profileUser)
            sharedViewModel.checkIfProfileUserIsFriend()
            sharedViewModel.tabPath[1].append("Profile")
        }
        else {
            if sharedViewModel.numOfClicksOnUsersFromProfileTab < sharedViewModel.searchTextListFromProfileTab.count {
                sharedViewModel.searchTextListFromProfileTab.removeLast()
            }
            sharedViewModel.numOfClicksOnUsersFromProfileTab+=1
            sharedViewModel.searchTextListFromProfileTab.append(sharedViewModel.searchTextFromProfileTab)
            sharedViewModel.profileUserListFromProfileTab.append(sharedViewModel.profileUser)
            sharedViewModel.checkIfProfileUserIsFriend()
            sharedViewModel.tabPath[4].append("Profile")
        }
    }
    
    func acceptRequest(index: Int) {
        Task {
            await acceptRequestOfUser(index: index)
        }
    }
    
    private func acceptRequestOfUser(index: Int) async {
        do {
            (sharedViewModel.currentUser.receiving, sharedViewModel.currentUser.friends) = try await repository.makeNewFriend(token: KeychainSwift().get("jwt") ?? "", userId: sharedViewModel.currentUser.id, requesterId: sharedViewModel.friendsOriginalFromProfileTab[index].id)
        } catch {
            print(error)
            if error.asAFError?.responseCode == 401 {
                sharedViewModel.unauthorizedAccess()
            }
        }
    }
    
    func rejectRequest(index: Int) {
        Task {
            await rejectRequestOfUser(index: index)
        }
    }
    
    private func rejectRequestOfUser(index: Int) async {
        do {
            (sharedViewModel.currentUser.receiving, sharedViewModel.currentUser.friends) = try await repository.deletePossibleFriend(token: KeychainSwift().get("jwt") ?? "", userId: sharedViewModel.currentUser.id, requesterId: sharedViewModel.friendsOriginalFromProfileTab[index].id)
        } catch {
            print(error)
            if error.asAFError?.responseCode == 401 {
                sharedViewModel.unauthorizedAccess()
            }
        }
    }
    
    func deleteFriend(index: Int) {
        Task {
            await deleteFriendFromCurrentUser(index: index)
        }
    }
    
    private func deleteFriendFromCurrentUser(index: Int) async {
        do {
            sharedViewModel.currentUser.friends = try await repository.deleteFriendship(token: KeychainSwift().get("jwt") ?? "", currentUserId: sharedViewModel.currentUser.id, friendUserId: sharedViewModel.friendsOriginalFromProfileTab[index].id)
        } catch {
            print(error)
            if error.asAFError?.responseCode == 401 {
                sharedViewModel.unauthorizedAccess()
            }
        }
    }
}
