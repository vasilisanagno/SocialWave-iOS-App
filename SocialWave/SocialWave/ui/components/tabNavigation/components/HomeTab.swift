import SwiftUI

//component for the tab of tab view that shows the home view
struct HomeTab: View {
    @ObservedObject var sharedViewModel: SharedViewModel
    @ObservedObject var socketViewModel: SocketViewModel
    @ObservedObject var profileViewModel: ProfileViewModel
    @ObservedObject var homeViewModel: HomeViewModel
    
    var body: some View {
        NavigationStack(path: $sharedViewModel.tabPath[0]) {
            ZStack {
                HomeView(sharedViewModel: sharedViewModel, socketViewModel: socketViewModel, profileViewModel: profileViewModel, homeViewModel: homeViewModel)
                    .padding(.top, 60)
                    .padding(.bottom, 60)
                FloatingActionButton()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack {
                        Image("appName")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 30)
                            .padding(.top, 7.5)
                        Divider()
                            .frame(width: 400, height: 1.2)
                            .background(.navyBlue)
                    }
                }
            }
        }
    }
}
