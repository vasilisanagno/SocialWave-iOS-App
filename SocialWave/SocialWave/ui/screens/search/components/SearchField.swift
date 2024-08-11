import SwiftUI

//component that shows the search field to search some other user
struct SearchField: View {
    @ObservedObject var searchViewModel: SearchViewModel
    @ObservedObject var sharedViewModel: SharedViewModel
    
    var body: some View {
        HStack {
            TextField("Search...", text: sharedViewModel.selectedTab == 2 ? $sharedViewModel.searchTextFromSearchTab :
                        $sharedViewModel.searchTextFromProfileTab)
                .padding(7)
                .padding(.horizontal, 25)
                .autocorrectionDisabled()
                .autocapitalization(.none)
                .background(.navyBlue.opacity(0.1))
                .cornerRadius(8)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(.navyBlue)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)
                        
                        if searchViewModel.isEditing {
                            Button(action: {
                                if sharedViewModel.selectedTab == 2 {
                                    sharedViewModel.searchTextFromSearchTab = ""
                                    sharedViewModel.filteredFriendsFromSearchTab = sharedViewModel.friendsOriginalFromSearchTab
                                }
                                else {
                                    sharedViewModel.searchTextFromProfileTab = ""
                                    sharedViewModel.filteredFriendsFromProfileTab = sharedViewModel.friendsOriginalFromProfileTab
                                }
                            }) {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundStyle(.navyBlue)
                                    .padding(.trailing, 8)
                            }
                        }
                    }
                )
                .padding(.horizontal, 10)
                .onTapGesture {
                    searchViewModel.isEditing = true
                }
                .onChange(of: sharedViewModel.selectedTab == 2 ? sharedViewModel.searchTextFromSearchTab : sharedViewModel.searchTextFromProfileTab) {
                    if sharedViewModel.selectedTab == 2 && sharedViewModel.tabPath[1].isEmpty {
                        searchViewModel.searchUsers()
                    }
                    else {
                        if sharedViewModel.selectedTab == 2 {
                            sharedViewModel.filteredFriendsFromSearchTab = searchViewModel.filterFriends()
                        }
                        else {
                            sharedViewModel.filteredFriendsFromProfileTab = searchViewModel.filterFriends()
                        }
                    }
                }

            if searchViewModel.isEditing {
                Button(action: {
                    searchViewModel.isEditing = false
                    if sharedViewModel.selectedTab == 2 {
                        sharedViewModel.searchTextFromSearchTab = ""
                        sharedViewModel.filteredFriendsFromSearchTab = sharedViewModel.friendsOriginalFromSearchTab
                    }
                    else {
                        sharedViewModel.searchTextFromProfileTab = ""
                        sharedViewModel.filteredFriendsFromProfileTab = sharedViewModel.friendsOriginalFromProfileTab
                    }
                    // Dismiss the keyboard
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }) {
                    Text("Cancel")
                }
                .padding(.trailing, 10)
                .transition(.move(edge: .trailing))
                .animation(.easeInOut, value: sharedViewModel.selectedTab == 2 ? sharedViewModel.searchTextFromSearchTab : sharedViewModel.searchTextFromProfileTab)
            }
        }
    }
}
