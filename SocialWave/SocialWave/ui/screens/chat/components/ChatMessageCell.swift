import SwiftUI

//component that shows the message according to if the user is the current or the other user
//with a design like cloud
struct ChatMessageCell: View {
    @ObservedObject var sharedViewModel: SharedViewModel
    let messageIndex: Int
    let isFromCurrentUser: Bool
    
    var body: some View {
        HStack {
            if isFromCurrentUser {
                Spacer()
                
                if sharedViewModel.messages[messageIndex].text != nil {
                    VStack(spacing: 3) {
                        Text(sharedViewModel.messages[messageIndex].text!)
                            .font(.subheadline)
                            .padding(12)
                            .background(.navyBlue)
                            .foregroundStyle(.white)
                            .clipShape(ChatBubble(isFromCurrentUser: isFromCurrentUser))
                            .frame(maxWidth: UIScreen.main.bounds.width / 1.5, alignment: .trailing)
                        Text(sharedViewModel.messages[messageIndex].createdAt)
                            .font(.footnote)
                            .foregroundStyle(.navyBlue.opacity(0.5))
                            .frame(maxWidth: UIScreen.main.bounds.width / 1.5, alignment: .trailing)
                        
                    }
                }
            }
            else {
                HStack(alignment: .bottom, spacing: 8) {
                    CircularProfileImage(user: nil, notif: nil, chat: sharedViewModel.inboxChats[sharedViewModel.selectedChat], comment: nil, width: 28, height: 28, type: "chat")
                        .foregroundStyle(.navyBlue)
                        .padding(.bottom, 10)
                    
                    if sharedViewModel.messages[messageIndex].text != nil {
                        VStack(spacing: 3) {
                            Text(sharedViewModel.messages[messageIndex].text!)
                                .font(.subheadline)
                                .padding(12)
                                .background(.navyBlue.opacity(0.2))
                                .foregroundStyle(.black)
                                .clipShape(ChatBubble(isFromCurrentUser: isFromCurrentUser))
                                .frame(maxWidth: UIScreen.main.bounds.width / 1.75, alignment: .leading)
                            
                            Text(sharedViewModel.messages[messageIndex].createdAt)
                                .font(.footnote)
                                .foregroundStyle(.navyBlue.opacity(0.5))
                                .frame(maxWidth: UIScreen.main.bounds.width / 1.75, alignment: .leading)
                        }
                    }
                    
                    Spacer()
                }
            }
        }
        .padding(.horizontal, 8)
    }
}
