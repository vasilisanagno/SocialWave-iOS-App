import SwiftUI

//view that shows the screen of the inbox with the different chats that have the current user in the chat tab
struct InboxView: View {
    @ObservedObject var sharedViewModel: SharedViewModel
    @ObservedObject var socketViewModel: SocketViewModel
    @ObservedObject var inboxViewModel: InboxViewModel
    @ObservedObject var chatViewModel: ChatViewModel
    @State private var showDialogDeleteChat = false
    @State private var selectedChat = 0
    
    var body: some View {
        List {
            if sharedViewModel.showProgress {
                SocialWaveCircularProgressBar()
                    .controlSize(.large)
                    .padding(.top, 250)
                    .frame(width: 800)
                    .listRowSeparator(.hidden)
            }
            else {
                ForEach(0..<sharedViewModel.inboxChats.count, id:\.self) { index in
                    InboxRow(sharedViewModel: sharedViewModel, socketViewModel: socketViewModel, inboxViewModel: inboxViewModel, chatViewModel: chatViewModel, index: index)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .listRowSeparator(.hidden)
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            Button {
                                selectedChat = index
                                showDialogDeleteChat.toggle()
                            } label: {
                                Image(systemName: "trash")
                                    .foregroundStyle(.white)
                            }
                            .tint(.red)
                        }
                        .onTapGesture {
                            sharedViewModel.selectedChat = index
                            chatViewModel.fetchMessagesTask(index: sharedViewModel.selectedChat)
                        }
                }
            }
        }
        .listStyle(PlainListStyle())
        .refreshable {
            inboxViewModel.getChatsTask(backButton: false)
        }
        .alert(isPresented: $showDialogDeleteChat) {
            Alert(
                title: Text("Delete Chat"),
                message: Text("Are you sure you want to delete this chat?"),
                primaryButton: .destructive(Text("Yes")) {
                    inboxViewModel.deleteChatTask(index: selectedChat)
                },
                secondaryButton: .cancel(Text("No")))
        }
        .fullScreenCover(isPresented: $inboxViewModel.showNewMessage) {
            NewMessage(sharedViewModel: sharedViewModel, socketViewModel: socketViewModel, inboxViewModel: inboxViewModel)
        }
        .onAppear {
            UIRefreshControl.appearance().tintColor = UIColor.navyBlue
            inboxViewModel.getChatsTask(backButton: false)
        }
    }
}
