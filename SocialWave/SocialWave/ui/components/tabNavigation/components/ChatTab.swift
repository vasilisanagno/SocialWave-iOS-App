import SwiftUI

//component for the tab of tab view that shows the chat view
struct ChatTab: View {
    @ObservedObject var sharedViewModel: SharedViewModel
    @ObservedObject var socketViewModel: SocketViewModel
    @ObservedObject var inboxViewModel: InboxViewModel
    @ObservedObject var chatViewModel: ChatViewModel
    
    var body: some View {
        NavigationStack(path: $sharedViewModel.tabPath[2]) {
            VStack {
                Divider()
                    .frame(width: 400, height: 1.2)
                    .background(.navyBlue)
                
                InboxView(sharedViewModel: sharedViewModel, socketViewModel: socketViewModel, inboxViewModel: inboxViewModel, chatViewModel: chatViewModel)
                    .padding(.top, -8)
            }
            .navigationTitle("Inbox")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    CircularProfileImage(user: sharedViewModel.currentUser, notif: nil, chat: nil, comment: nil, width: 32, height: 32, type: "profile")
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        inboxViewModel.getFriendsForNewChatsTask()
                    } label: {
                        Image(systemName: "square.and.pencil")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundStyle(.navyBlue)
                    }
                }
            }
        }
    }
}
