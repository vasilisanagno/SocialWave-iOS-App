import SwiftUI

//component that shows the message input view
struct MessageInput: View {
    @ObservedObject var sharedViewModel: SharedViewModel
    @ObservedObject var chatViewModel: ChatViewModel
    
    var body: some View {
        ZStack(alignment: .trailing) {
            TextField("Message...", text: $chatViewModel.messageText, axis: .vertical)
                .padding(12)
                .padding(.trailing, 48)
                .background(Color(.systemGroupedBackground))
                .clipShape(Capsule())
                .font(.subheadline)
                .lineLimit(3)
                .autocapitalization(.none)
                .autocorrectionDisabled()
                .tint(.navyBlue)
            
            Button {
                if chatViewModel.messageText.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
                    chatViewModel.createMessageTask(index: sharedViewModel.selectedChat, text: chatViewModel.messageText.trimmingCharacters(in: .whitespacesAndNewlines))
                    chatViewModel.messageText = ""
                }
            } label: {
                Image(systemName: "paperplane.fill")
                    .foregroundStyle(.navyBlue)
            }
            .padding(.horizontal)
        }
        .padding()
        .padding(.bottom, -20)
        .padding(.top, -5)
    }
}
