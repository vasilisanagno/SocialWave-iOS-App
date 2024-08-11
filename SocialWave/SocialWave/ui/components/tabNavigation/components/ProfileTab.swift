import SwiftUI

//component for the tab of tab view that shows the profile view
struct ProfileTab: View {
    @ObservedObject var sharedViewModel: SharedViewModel
    @ObservedObject var socketViewModel: SocketViewModel
    @ObservedObject var searchViewModel: SearchViewModel
    @ObservedObject var profileViewModel: ProfileViewModel
    @ObservedObject var homeViewModel: HomeViewModel
    
    var body: some View {
        NavigationStack(path: $sharedViewModel.tabPath[4]) {
            VStack {
                Divider()
                    .frame(width: 400, height: 1.2)
                    .background(.navyBlue)
                
                ProfileView(sharedViewModel: sharedViewModel, socketViewModel: socketViewModel, profileViewModel: profileViewModel, homeViewModel: homeViewModel)
                    .padding(.top, -10)
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Profile")
            .toolbar {
                if sharedViewModel.currentUser.id == sharedViewModel.profileUser.id {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            //action
                            withAnimation(.spring()) {
                                sharedViewModel.showSettings.toggle()
                            }
                        } label: {
                            Image(systemName: "gearshape")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 20)
                        }
                        .padding(.leading, 10)
                        .disabled(sharedViewModel.showProgress)
                    }
                
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            //action
                            sharedViewModel.showEditProfile.toggle()
                            sharedViewModel.showSettings = false
                        } label: {
                            Image(systemName: "pencil")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 20)
                        }
                        .padding(.trailing, 10)
                        .disabled(sharedViewModel.showProgress)
                    }
                }
            }
            .navigationDestination(for: String.self) { destination in
                switch destination {
                    case "Profile":
                    GoToProfile(profileViewModel: profileViewModel, sharedViewModel: sharedViewModel, socketViewModel: socketViewModel, homeViewModel: homeViewModel)
                    
                    case "Search Friends":
                    GoToSearch(searchViewModel: searchViewModel, sharedViewModel: sharedViewModel, profileViewModel: profileViewModel)
                    
                    default:
                        EmptyView()
                }
            }
        }
    }
}
