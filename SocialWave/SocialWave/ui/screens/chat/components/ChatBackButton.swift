import SwiftUI

//component that shows the back button inside the chat messages for a specific chat
struct ChatBackButton: View {
    @ObservedObject var sharedViewModel: SharedViewModel
    @ObservedObject var inboxViewModel: InboxViewModel
    @ObservedObject var chatViewModel: ChatViewModel
    let dismiss: DismissAction
    
    var body: some View {
        HStack(spacing: 5) {
            Image(systemName: "chevron.left")
                .imageScale(.large)
                .onTapGesture {
                    chatViewModel.messageText = ""
                    inboxViewModel.getChatsTask(backButton: true)
                    dismiss()
                }
                .foregroundStyle(Color.navyBlue)
            CircularProfileImage(user: nil, notif: nil, chat: sharedViewModel.inboxChats[sharedViewModel.selectedChat], comment: nil, width: 28, height: 28, type: "chat")
                .foregroundStyle(.navyBlue)
                .padding(.trailing, 3)
            Text(sharedViewModel.inboxChats[sharedViewModel.selectedChat].chatMemberUsername)
                .fontWeight(.semibold)
                .font(.system(size: 16))
                .foregroundStyle(.navyBlue)
        }
        .padding(.leading, 10)
    }
}
