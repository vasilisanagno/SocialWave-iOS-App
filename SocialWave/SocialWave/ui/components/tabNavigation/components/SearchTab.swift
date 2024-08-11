import SwiftUI

//component for the tab of tab view that shows the search view
struct SearchTab: View {
    @ObservedObject var searchViewModel: SearchViewModel
    @ObservedObject var sharedViewModel: SharedViewModel
    @ObservedObject var socketViewModel: SocketViewModel
    @ObservedObject var profileViewModel: ProfileViewModel
    @ObservedObject var homeViewModel: HomeViewModel
    
    var body: some View {
        NavigationStack(path: $sharedViewModel.tabPath[1]) {
            SearchView(searchViewModel: searchViewModel, sharedViewModel: sharedViewModel, profileViewModel: profileViewModel)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("Find Friends")
                            .bold()
                            .font(.system(size: 20))
                            .foregroundStyle(.navyBlue)
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
