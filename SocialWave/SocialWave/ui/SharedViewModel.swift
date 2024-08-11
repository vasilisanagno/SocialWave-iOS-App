import Foundation
import KeychainSwift

//view model class that keeps the shared variables across the entire app
class SharedViewModel: ObservableObject {
    //helps in the navigation for login,signup,otp verification and reset password
    @Published var startPath: [String] = []
    //helps in the navigation in the different tabs
    @Published var tabPath: [[String]] = Array(repeating: Array(repeating: "", count: 0), count: 5)
    
    //shows the circular progress bar
    @Published var showProgress: Bool = false
    
    //variable that make disable the button of the verification of OTP 
    @Published var disabled: Bool = true
    
    //variables to keep the variables of the textfields
    @Published var otp: [String] = []
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var username: String = ""
    @Published var confirmPassword: String = ""
    
    //variables for the red border in the textfields
    @Published var emailError: Bool = false
    @Published var passwordError: Bool = false
    @Published var confirmPasswordError: Bool = false
    @Published var usernameError: Bool = false
    
    //variables for errors in the process of login,signup,otpCheck adn resetPassword
    @Published var errorCodeEmail: Int = -1
    @Published var errorCodePassword: Int = -1
    @Published var errorCodeConfirmPassword: Int = -1
    @Published var errorCodeSignup: Int = -1
    @Published var errorCodeLogin: Int = -1
    @Published var errorCodeOTP: Int = -1
    @Published var errorCodeWrongEmail: Int = -1
    @Published var errorLogin: Bool = false
    @Published var errorSignup: Bool = false
    @Published var errorOTP: Bool = false
    @Published var errorWrongEmail: Bool = false
    
    //variable that helps for the navigation when the user clicks the login button to the tab navigation view
    @Published var loginSuccess: Bool = false
    //auto login without need for login again when the app close
    @Published var autoLogin: Bool = false
    //current user that login to the app with the details
    @Published var currentUser: UserDetails = UserDetails()
    @Published var currentUserPosts: [PostDetails] = []
    
    //posts of current user's friends
    @Published var friendsPosts: [PostDetails] = []
    
    //edit profile variables
    @Published var fullname: String = ""
    @Published var description: String = ""
    @Published var caption: String = ""
    
    //user details that will be shown in the profile
    @Published var profileUser: UserDetails = UserDetails()
    @Published var profileUserPosts: [PostDetails] = []
    //keeps the different list of profile users for the back buttons
    @Published var profileUserListFromSearchTab: [UserDetails] = []
    @Published var profileUserListFromProfileTab: [UserDetails] = []
    
    //is the user of the first that is searched in the search tab
    @Published var searchUser: UserDetails = UserDetails()
    
    //varivale to keep the users in the serach view
    @Published var users = [UserDetails]()
    //original data of friends of the users, helps in the filtering of the search when the text becomes empty again
    @Published var friendsOriginalFromSearchTab: [UserDetails] = []
    @Published var friendsOriginalFromProfileTab: [UserDetails] = []
    //for the different list of paths either search or profile tab
    @Published var filteredFriendsFromSearchTab: [UserDetails] = []
    @Published var filteredFriendsFromProfileTab: [UserDetails] = []
    //keeps the different list of friends for the back buttons
    @Published var friendsListPathFromSearchTab: [[UserDetails]] = []
    @Published var friendsListPathFromProfileTab: [[UserDetails]] = []
    
    //keeps the friends of a user that liked his post
    @Published var friendsLikedPost: [UserDetails] = []
    
    //for the different texts either search or profile tab
    @Published var searchTextFromSearchTab: String = ""
    @Published var searchTextFromProfileTab: String = ""
    //keeps the different list of texts for the back buttons
    @Published var searchTextListFromSearchTab: [String] = []
    @Published var searchTextListFromProfileTab: [String] = []
    @Published var numOfClicksOnUsersFromSearchTab = 0
    @Published var numOfClicksOnUsersFromProfileTab = 0
    
    //variable for double tab in the home tab
    @Published var firstHomePost = false
    
    //indicator for each tab
    @Published var selectedTab = 1 {
        didSet {
            if oldValue == selectedTab {
                if selectedTab == 1 {
                    firstHomePost = true
                }
                else if selectedTab == 2 {
                    if searchTextListFromSearchTab.count != 0 {
                        searchTextFromSearchTab = searchTextListFromSearchTab[0]
                    }
                    searchTextListFromSearchTab = []
                    numOfClicksOnUsersFromSearchTab = 0
                    friendsListPathFromSearchTab = []
                    filteredFriendsFromSearchTab = []
                    friendsOriginalFromSearchTab = []
                    profileUserListFromSearchTab = []
                    friendsOrNotFromSearchTab = false
                    pendingOrNotFromSearchTab = false
                    tabPath[1].removeAll()
                }
                else if selectedTab == 5 {
                    searchTextFromProfileTab = ""
                    searchTextListFromProfileTab = []
                    numOfClicksOnUsersFromProfileTab = 0
                    friendsListPathFromProfileTab = []
                    filteredFriendsFromProfileTab = []
                    friendsOriginalFromProfileTab = []
                    profileUserListFromProfileTab = []
                    friendsOrNotFromProfileTab = false
                    pendingOrNotFromProfileTab = false
                    profileUser = currentUser
                    tabPath[4].removeAll()
                }
            }
        }
    }
    
    //variable for the "Profile" view to show the toolbar items
    @Published var showSettings: Bool = false
    @Published var showEditProfile: Bool = false
    
    //variable for options in the post
    @Published var showOptions: Bool = false
    
    //users and their comments in posts
    @Published var postComments: [CommentDetails] = []
    
    @Published var friendsOrRequests: Bool = false //false is for friends, true for requests
    @Published var friendsOrNotFromSearchTab: Bool = false
    @Published var friendsOrNotFromProfileTab: Bool = false
    
    //variable for button add friend
    @Published var pendingOrNotFromSearchTab: Bool = false
    @Published var pendingOrNotFromProfileTab: Bool = false
    
    @Published var requestScreenNow = false
    
    //list of suggested friends
    @Published var suggestedFriends: [SuggestedFriendDetails] = []
    @Published var suggestedFriend: SuggestedFriendDetails = SuggestedFriendDetails()
    
    //list of notifications of the current user
    @Published var notifications: [NotificationDetails] = []
    @Published var numOfUnseenNotif = 0
    
    //varibales for chat
    @Published var inboxChats: [ChatDetails] = []
    @Published var friendsWithoutChatYetOriginal: [UserDetails] = []
    @Published var friendsWithoutChatYet: [UserDetails] = []
    @Published var selectedChat = 0
    @Published var numOfUnseenChats = 0
    
    @Published var messages: [MessageDetails] = []
    @Published var goToTheLastMessage = false
    
    
    //function that is called when the token is verified wrong from the server
    func unauthorizedAccess() {
        let keychain = KeychainSwift()
        keychain.delete("jwt")
        password = ""
        email = ""
        startPath.removeAll()
        for i in 0..<5 {
            tabPath[i].removeAll()
        }
        showProgress = false
        loginSuccess = false
        autoLogin = false
    }
    
    //checks if the the profile user is friend with the current user
    func checkIfProfileUserIsFriend() {
        for i in 0..<currentUser.friends.count {
            if currentUser.friends[i] == profileUser.id {
                if selectedTab == 2 {
                    friendsOrNotFromSearchTab = true
                }
                else {
                    friendsOrNotFromProfileTab = true
                }
                break
            }
            else {
                if i == currentUser.friends.count-1 {
                    if selectedTab == 2 {
                        friendsOrNotFromSearchTab = false
                    }
                    else {
                        friendsOrNotFromProfileTab = false
                    }
                }
            }
        }
    }
    
    //function that is called when tab changes
    func tabNavigationChange() {
        if selectedTab == 2 && !tabPath[1].isEmpty {
            if profileUserListFromSearchTab.last != nil {
                profileUser = profileUserListFromSearchTab.last!
            }
        }
        else if selectedTab == 2 && tabPath[1].isEmpty {
            profileUser = searchUser
        }
        else if selectedTab == 5 && !tabPath[4].isEmpty {
            if profileUserListFromProfileTab.last != nil {
                profileUser = profileUserListFromProfileTab.last!
            }
            else {
                profileUser = currentUser
            }
        }
        else if selectedTab == 5 && tabPath[4].isEmpty {
            profileUser = currentUser
            profileUserPosts = currentUserPosts
        }
        
        if selectedTab != 5 {
            showSettings = false
            friendsOrRequests = false
        }
        else {
            if tabPath[4].last == "Search Friends" && requestScreenNow {
                friendsOrRequests = true
            }
        }
    }
}
