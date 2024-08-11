import SwiftUI

//component that shows the profile stats altogether in a row
struct ProfileStats: View {
    @ObservedObject var sharedViewModel: SharedViewModel
    @ObservedObject var profileViewModel: ProfileViewModel
    
    var body: some View {
        HStack(spacing: 5) {
            UserStatistics(value: sharedViewModel.profileUser.posts.count, title: "Posts")
            
            //The divider is vertical because is placed in a HStack and between two items
            Divider()
                .padding(.leading, 5)
                .padding(.trailing, 5)
            
            UserStatistics(value: sharedViewModel.profileUser.friends.count, title: "Friends")
                .onTapGesture {
                    if sharedViewModel.profileUser.friends.count != 0 && (((sharedViewModel.selectedTab == 2 && sharedViewModel.friendsOrNotFromSearchTab) || (sharedViewModel.selectedTab == 5 && sharedViewModel.friendsOrNotFromProfileTab)) || sharedViewModel.profileUser.id == sharedViewModel.currentUser.id) {
                        profileViewModel.findFriends()
                    }
                }
                .disabled(sharedViewModel.showProgress)
            
            if sharedViewModel.profileUser.id == sharedViewModel.currentUser.id {
                Divider()
                    .padding(.leading, 5)
                    .padding(.trailing, 5)
                
                UserStatistics(value: sharedViewModel.profileUser.receiving.count, title: "Requests")
                    .onTapGesture {
                        if sharedViewModel.profileUser.receiving.count != 0 {
                            sharedViewModel.requestScreenNow = true
                            profileViewModel.findRequests()
                        }
                    }
                    .disabled(sharedViewModel.showProgress)
            }
        }
    }
}
