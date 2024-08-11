import SwiftUI

//view that shows the screen of profile of the current user
struct ProfileView: View {
    @ObservedObject var sharedViewModel: SharedViewModel
    @ObservedObject var socketViewModel: SocketViewModel
    @StateObject var profileViewModel: ProfileViewModel = ProfileViewModel()
    @ObservedObject var homeViewModel: HomeViewModel
    @State private var showFriends: Bool = false
    @State private var clickedIndex: Int = 0
    
    var body: some View {
        ZStack {
            ScrollView(.vertical, showsIndicators: false) {

                ProfileDetails(sharedViewModel: sharedViewModel, profileViewModel: profileViewModel, socketViewModel: socketViewModel, homeViewModel: homeViewModel)
                
                if sharedViewModel.showProgress {
                    SocialWaveCircularProgressBar()
                        .controlSize(.large)
                        .padding(.top, 50)
                }
                else {
                    if ((sharedViewModel.selectedTab == 2 && !sharedViewModel.friendsOrNotFromSearchTab) || (sharedViewModel.selectedTab == 5 && !sharedViewModel.friendsOrNotFromProfileTab)) && sharedViewModel.profileUser.id != sharedViewModel.currentUser.id {
                        
                        NotFriendsYet(sharedViewModel: sharedViewModel, profileViewModel: profileViewModel)
                    }
                    else {
                        //post grid view
                        GridPostList(sharedViewModel: sharedViewModel, profileViewModel: profileViewModel)
                    }
                }
            }
            .refreshable {
                if !sharedViewModel.showProgress {
                    profileViewModel.reloadUserDetailsInProfileTask()
                }
            }
            .onAppear {
                UIRefreshControl.appearance().tintColor = UIColor.navyBlue
            }
            
            if sharedViewModel.showSettings {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        withAnimation(.easeIn) {
                            sharedViewModel.showSettings = false
                        }
                    }
                
                Settings(profileViewModel: profileViewModel)
                    .frame(maxWidth: .infinity, maxHeight: 180)
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(radius: 10)
                    .offset(y: sharedViewModel.showSettings ? 300 : UIScreen.main.bounds.height)
                    .animation(.spring(dampingFraction: 0.8), value: sharedViewModel.showSettings)
                    .transition(.move(edge: .bottom))
            }
        }
        .onAppear {
            profileViewModel.reloadUserDetailsInProfileTask()
        }
    }
}
