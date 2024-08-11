import SwiftUI

//component that is useful when search for other friends profiles to go back to the search view
struct ProfileBackButton: View {
    @ObservedObject var profileViewModel: ProfileViewModel
    
    var body: some View {
        Image(systemName: "chevron.left")
            .imageScale(.large)
            .onTapGesture {
                profileViewModel.getBackButtonDetails()
            }
            .foregroundStyle(Color.navyBlue)
    }
}
