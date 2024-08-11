import SwiftUI

//component that shows the list of friends that could make the current user a new chat
struct FriendsList: View {
    @ObservedObject var sharedViewModel: SharedViewModel
    @ObservedObject var socketViewModel: SocketViewModel
    @ObservedObject var inboxViewModel: InboxViewModel
    let dismiss: DismissAction
    @State private var showDialogCreateChat = false
    @State private var selectedUser = 0
    
    var body: some View {
        ScrollView {
            if sharedViewModel.showProgress {
                SocialWaveCircularProgressBar()
                    .controlSize(.large)
                    .padding(.top, 250)
            }
            else {
                LazyVStack(alignment: .leading, spacing: 12) {
                    ForEach(0..<sharedViewModel.friendsWithoutChatYet.count, id: \.self) { user in
                        HStack {
                            CircularProfileImage(user: sharedViewModel.friendsWithoutChatYet[user], notif: nil, chat: nil, comment: nil, width: 40, height: 40, type: "profile")
                            
                            VStack(alignment: .leading) {
                                Text(sharedViewModel.friendsWithoutChatYet[user].username)
                                    .fontWeight(.semibold)
                                    .font(.system(size: 16))
                            }
                            .font(.footnote)
                        }
                        .padding(.top, user == 0 ? 12 : 0)
                        .padding(.horizontal)
                        .onTapGesture {
                            showDialogCreateChat = true
                            selectedUser = user
                        }
                    }
                }
                .padding(.bottom, 8)
                .foregroundStyle(.navyBlue)
            }
        }
        .padding(.top, -7.5)
        .alert(isPresented: $showDialogCreateChat) {
            Alert(
                title: Text("Create Chat"),
                message: Text("Are you sure you want to create a chat with this friend?"),
                primaryButton: .destructive(Text("Yes")) {
                    inboxViewModel.createChatTask(dismiss: dismiss, index: selectedUser)
                    socketViewModel.createChat(usernameFirst: sharedViewModel.currentUser.username, usernameSecond: sharedViewModel.friendsWithoutChatYet[selectedUser].username)
            },
            secondaryButton: .cancel(Text("No")))
        }
    }
}
