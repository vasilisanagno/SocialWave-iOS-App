import SwiftUI

//component that shows the text field that is for the search in the friends
//that the current user does not have yet a chat
struct NewMessageSearch: View {
    @ObservedObject var sharedViewModel: SharedViewModel
    @ObservedObject var inboxViewModel: InboxViewModel
    @State private var isEditing = false
    @State private var searchText = ""
    
    var body: some View {
        HStack {
            TextField("To:", text: $searchText)
                .padding(7)
                .padding(.horizontal, 25)
                .autocorrectionDisabled()
                .autocapitalization(.none)
                .background(.navyBlue.opacity(0.1))
                .cornerRadius(8)
                .tint(.navyBlue)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(.navyBlue)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)
                        
                        if isEditing {
                            Button(action: {
                                searchText = ""
                                sharedViewModel.friendsWithoutChatYet = inboxViewModel.filterFriends(searchText: searchText)
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
                    isEditing = true
                }
                .onChange(of: searchText) {
                    sharedViewModel.friendsWithoutChatYet = inboxViewModel.filterFriends(searchText: searchText)
                }

            if isEditing {
                Button(action: {
                    isEditing = false
                    searchText = ""
                    sharedViewModel.friendsWithoutChatYet = inboxViewModel.filterFriends(searchText: searchText)
                    // Dismiss the keyboard
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }) {
                    Text("Cancel")
                }
                .padding(.trailing, 10)
                .transition(.move(edge: .trailing))
                .animation(.easeInOut, value: searchText)
            }
        }
    }
}
