import SwiftUI

//view that shows the chat screen when the user clicks in one specific chat
struct ChatView: View {
    @ObservedObject var sharedViewModel: SharedViewModel
    @ObservedObject var socketViewModel: SocketViewModel
    @ObservedObject var inboxViewModel: InboxViewModel
    @ObservedObject var chatViewModel: ChatViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            HStack {
                ChatBackButton(sharedViewModel: sharedViewModel, inboxViewModel: inboxViewModel, chatViewModel: chatViewModel, dismiss: dismiss)
                Spacer()
            }
            
            ScrollViewReader { value in
                ScrollView(.vertical, showsIndicators: false) {
                    //header
                    VStack {
                        CircularProfileImage(user: nil, notif: nil, chat: sharedViewModel.inboxChats[sharedViewModel.selectedChat], comment: nil, width: 80, height: 80, type: "chat")
                            .foregroundStyle(.navyBlue)
                        
                        VStack(spacing: 4) {
                            Text(sharedViewModel.inboxChats[sharedViewModel.selectedChat].chatMemberUsername)
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundStyle(.navyBlue)
                            
                            if sharedViewModel.inboxChats[sharedViewModel.selectedChat].chatMemberFullname != nil {
                                Text(sharedViewModel.inboxChats[sharedViewModel.selectedChat].chatMemberFullname!)
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.navyBlue)
                            }
                            
                            Text("SocialWave")
                                .font(.footnote)
                                .foregroundStyle(.navyBlue.opacity(0.3))
                                .padding(.bottom, 10)
                        }
                    }
                    
                    ForEach(0..<sharedViewModel.messages.count, id: \.self) { message in
                        ChatMessageCell(sharedViewModel: sharedViewModel, messageIndex: message, isFromCurrentUser: sharedViewModel.currentUser.id == sharedViewModel.messages[message].sender ? true : false)
                    }
                }
                .onAppear {
                    value.scrollTo(sharedViewModel.messages.count-1, anchor: .bottom)
                }
                .onChange(of: sharedViewModel.goToTheLastMessage) {
                    if sharedViewModel.goToTheLastMessage {
                        value.scrollTo(sharedViewModel.messages.count-1, anchor: .bottom)
                        sharedViewModel.goToTheLastMessage.toggle()
                    }
                }
            }
            
            Spacer()
            MessageInput(sharedViewModel: sharedViewModel, chatViewModel: chatViewModel)
        }
    }
}
