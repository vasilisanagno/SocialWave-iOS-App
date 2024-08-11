import SwiftUI

//view that shows the screen of the search view when to search someone's profile
struct SearchView: View {
    @ObservedObject var searchViewModel: SearchViewModel
    @ObservedObject var sharedViewModel: SharedViewModel
    @ObservedObject var profileViewModel: ProfileViewModel
    
    var body: some View {
        VStack {
            SearchField(searchViewModel: searchViewModel, sharedViewModel: sharedViewModel)
            
            Divider()
                .frame(width: 400, height: 1.2)
                .background(.navyBlue)
            ScrollView {
                if sharedViewModel.showProgress {
                    SocialWaveCircularProgressBar()
                        .controlSize(.large)
                        .padding(.top, 250)
                }
                else {
                    LazyVStack(alignment: .leading, spacing: 12) {
                        ForEach(0..<((sharedViewModel.selectedTab == 2 && sharedViewModel.tabPath[1].last == "Search Friends") ? sharedViewModel.filteredFriendsFromSearchTab.count : (sharedViewModel.selectedTab == 5 ? sharedViewModel.filteredFriendsFromProfileTab.count : sharedViewModel.users.count)), id: \.self) { user in
                            HStack {
                                CircularProfileImage(user: ((sharedViewModel.selectedTab == 2 && sharedViewModel.tabPath[1].last == "Search Friends") ? sharedViewModel.filteredFriendsFromSearchTab[user] : (sharedViewModel.selectedTab == 5) ? sharedViewModel.filteredFriendsFromProfileTab[user] :  sharedViewModel.users[user]), notif: nil, chat: nil, comment: nil, width: 40, height: 40, type: "profile")
                                
                                VStack(alignment: .leading) {
                                    Text(((sharedViewModel.selectedTab == 2 && sharedViewModel.tabPath[1].last == "Search Friends") ? sharedViewModel.filteredFriendsFromSearchTab[user].username : (sharedViewModel.selectedTab == 5) ? sharedViewModel.filteredFriendsFromProfileTab[user].username : sharedViewModel.users[user].username))
                                        .fontWeight(.semibold)
                                        .font(.system(size: 16))
                                    if (((sharedViewModel.selectedTab == 2 && sharedViewModel.tabPath[1].last == "Search Friends") ? sharedViewModel.filteredFriendsFromSearchTab[user].fullname != nil : (sharedViewModel.selectedTab == 5) ? sharedViewModel.filteredFriendsFromProfileTab[user].fullname != nil : sharedViewModel.users[user].fullname != nil)) {
                                        Text(((sharedViewModel.selectedTab == 2 && sharedViewModel.tabPath[1].last == "Search Friends") ? sharedViewModel.filteredFriendsFromSearchTab[user].fullname : (sharedViewModel.selectedTab == 5) ? sharedViewModel.filteredFriendsFromProfileTab[user].fullname : sharedViewModel.users[user].fullname)!)
                                            .font(.system(size: 14))
                                    }
                                }
                                .font(.footnote)
                                
                                if sharedViewModel.friendsOrRequests {
                                    Spacer()
                                    
                                    AcceptOrRejectRequest(searchViewModel: searchViewModel, user: user)
                                }
                                else if sharedViewModel.profileUser.id == sharedViewModel.currentUser.id && sharedViewModel.selectedTab == 5 {
                                    Spacer()
                                    
                                    DeleteFriend(searchViewModel: searchViewModel, user: user)
                                }
                            }
                            .padding(.top, user == 0 ? 12 : 0)
                            .padding(.horizontal)
                            .onTapGesture {
                                searchViewModel.goToTheNextUser(user: user)
                            }
                        }
                    }
                    .padding(.bottom, 8)
                    .foregroundStyle(.navyBlue)
                }
            }
            .padding(.top, -7.5)
        }
    }
}
