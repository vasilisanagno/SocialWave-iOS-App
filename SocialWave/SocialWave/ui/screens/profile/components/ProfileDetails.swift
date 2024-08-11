import SwiftUI

//component that shows all the profile details
struct ProfileDetails: View {
    @ObservedObject var sharedViewModel: SharedViewModel
    @ObservedObject var profileViewModel: ProfileViewModel
    @ObservedObject var socketViewModel: SocketViewModel
    @ObservedObject var homeViewModel: HomeViewModel
    
    var body: some View {
        ZStack {
            VStack(spacing: 10) {
                //photo profile
                CircularProfileImage(user: sharedViewModel.profileUser, notif: nil, chat: nil, comment: nil, width: 80, height: 80, type: "profile")
                
                //username
                Text(sharedViewModel.profileUser.username)
                    .font(.footnote)
                    .fontWeight(.semibold)
                
                ProfileStats(sharedViewModel: sharedViewModel, profileViewModel: profileViewModel)
                
                //fullname
                if sharedViewModel.profileUser.fullname != nil {
                    Text(sharedViewModel.profileUser.fullname!)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .padding(.leading, 10)
                        .padding(.trailing, 10)
                }
                //description
                if sharedViewModel.profileUser.description != nil {
                    Text(sharedViewModel.profileUser.description!)
                        .font(.footnote)
                        .padding(.leading, 7.5)
                        .padding(.trailing, 7.5)
                }
                
                Divider()
                    .frame(height: 1.2)
                    .background(.navyBlue)
            }
            .padding(.top, 10)
            .fullScreenCover(isPresented: $sharedViewModel.showEditProfile) {
                EditProfileView(sharedViewModel: sharedViewModel)
            }
            .sheet(isPresented: $profileViewModel.postClicked, onDismiss: { profileViewModel.postClicked = false }) {
                PostReader(sharedViewModel: sharedViewModel, socketViewModel: socketViewModel, profileViewModel: profileViewModel, homeViewModel: homeViewModel)
            }
        }
    }
}
