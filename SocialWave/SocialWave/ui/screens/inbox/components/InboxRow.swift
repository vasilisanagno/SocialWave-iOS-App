import SwiftUI

//component that shows details about a chat when they are shown in the inbox
struct InboxRow: View {
    @ObservedObject var sharedViewModel: SharedViewModel
    @ObservedObject var socketViewModel: SocketViewModel
    @ObservedObject var inboxViewModel: InboxViewModel
    @ObservedObject var chatViewModel: ChatViewModel
    let index: Int
    @State private var selectedIndex = 0
    
    var body: some View {
        if sharedViewModel.inboxChats.count > index {
            ZStack(alignment: .leading) {
                HStack(alignment: .center, spacing: 12) {
                    CircularProfileImage(user: nil, notif: nil, chat: sharedViewModel.inboxChats[index], comment: nil, width: 50, height: 50, type: "chat")
                        .padding(.bottom, index == sharedViewModel.inboxChats.count - 1 ? 8 : 0)
                    VStack(alignment: .leading, spacing: 4) {
                        
                        Text(sharedViewModel.inboxChats[index].chatMemberUsername)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .lineLimit(1)
                            .foregroundStyle(.navyBlue)
                            .frame(width: 150, alignment: .leading)
                            .bold(!sharedViewModel.inboxChats[index].lastMessageSeen)
                        
                        if sharedViewModel.inboxChats[index].lastMessage != nil {
                            Text(sharedViewModel.inboxChats[index].lastMessage!)
                                .font(.subheadline)
                                .lineLimit(1)
                                .foregroundStyle(!sharedViewModel.inboxChats[index].lastMessageSeen ? .navyBlue.opacity(0.8) : .navyBlue.opacity(0.4))
                                .padding(.trailing, 15)
                                .padding(.bottom, index == sharedViewModel.inboxChats.count - 1 ? 8 : 0)
                                .frame(width: 200, alignment: .leading)
                                .bold(!sharedViewModel.inboxChats[index].lastMessageSeen)
                        }
                        else {
                            Text("No message yet in this chat")
                                .font(.subheadline)
                                .lineLimit(1)
                                .foregroundStyle(.navyBlue)
                                .padding(.trailing, 15)
                                .padding(.bottom, index == sharedViewModel.inboxChats.count - 1 ? 8 : 0)
                        }
                    }
                }
                .fullScreenCover(isPresented: $chatViewModel.showChat) {
                    ChatView(sharedViewModel: sharedViewModel, socketViewModel: socketViewModel, inboxViewModel: inboxViewModel, chatViewModel: chatViewModel)
                }
                if sharedViewModel.inboxChats[index].lastMessageCreatedAt != "Invalid date" {
                    HStack(spacing: 4) {
                        Text(sharedViewModel.inboxChats[index].lastMessageCreatedAt!)
                            .font(.system(size: 12))
                        
                        Image(systemName: "chevron.right")
                    }
                    .font(.footnote)
                    .foregroundStyle(!sharedViewModel.inboxChats[index].lastMessageSeen ? .navyBlue.opacity(0.8) : .navyBlue.opacity(0.4))
                    .padding(.leading, 270)
                    .padding(.bottom, 20)
                    .bold(!sharedViewModel.inboxChats[index].lastMessageSeen)
                }
            }
        }
    }
}
