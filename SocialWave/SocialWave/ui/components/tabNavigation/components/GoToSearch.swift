import SwiftUI

//component that is used for the navigation destination and go to the search view
struct GoToSearch: View {
    @ObservedObject var searchViewModel: SearchViewModel
    @ObservedObject var sharedViewModel: SharedViewModel
    @ObservedObject var profileViewModel: ProfileViewModel
    
    var body: some View {
        SearchView(searchViewModel: searchViewModel, sharedViewModel: sharedViewModel, profileViewModel: profileViewModel)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    SearchBackButton(searchViewModel: searchViewModel)
                }
                ToolbarItem(placement: .principal) {
                    Text(!sharedViewModel.friendsOrRequests ? "Friends" : "Requests")
                        .bold()
                        .font(.system(size: 20))
                        .foregroundStyle(.navyBlue)
                }
            }
            .navigationBarBackButtonHidden(true)
    }
}
