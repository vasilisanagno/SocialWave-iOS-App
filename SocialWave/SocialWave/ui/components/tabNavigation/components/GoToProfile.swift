import SwiftUI

//component that is used for the navigation destination and go to the profile view
struct GoToProfile: View {
    @ObservedObject var profileViewModel: ProfileViewModel
    @ObservedObject var sharedViewModel: SharedViewModel
    @ObservedObject var socketViewModel: SocketViewModel
    @ObservedObject var homeViewModel: HomeViewModel
    
    var body: some View {
        VStack {
            Divider()
                .frame(width: 400, height: 1.2)
                .background(.navyBlue)
            
            ProfileView(sharedViewModel: sharedViewModel, socketViewModel: socketViewModel, homeViewModel: homeViewModel)
                .padding(.top, -10)
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Profile")
        .toolbar {
            //back button
            ToolbarItem(placement: .topBarLeading) {
                ProfileBackButton(profileViewModel: profileViewModel)
            }
        }
    }
}
