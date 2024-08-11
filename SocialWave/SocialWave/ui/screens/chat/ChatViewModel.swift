import Foundation
import KeychainSwift

//view model that keeps the variable state across multiple views and communicates with the server
//to create a message and fetch the messages for a chat
@MainActor
class ChatViewModel: ObservableObject {
    private let repository: ChatRepository
    private let sharedViewModel: SharedViewModel
    private let socketViewModel: SocketViewModel
    @Published var showChat = false
    @Published var messageText = ""
    
    init(repository: ChatRepository = DIContainer.shared.container.resolve(ChatRepository.self)!,
         socketViewModel: SocketViewModel = DIContainer.shared.container.resolve(SocketViewModel.self)!,
         sharedViewModel: SharedViewModel = DIContainer.shared.container.resolve(SharedViewModel.self)!) {
        self.repository = repository
        self.socketViewModel = socketViewModel
        self.sharedViewModel = sharedViewModel
    }
    
    func createMessageTask(index: Int, text: String) {
        Task {
            await createMessage(index: index, text: text)
        }
    }
    
    func createMessage(index: Int, text: String) async {
        do {
            sharedViewModel.messages.append(try await repository.createMessageInAChat(token: KeychainSwift().get("jwt") ?? "", currentUserId: sharedViewModel.currentUser.id, chatMemberId: sharedViewModel.inboxChats[index].chatMemberId, chatMemberUsername: sharedViewModel.inboxChats[index].chatMemberUsername, text: text))
            try await repository.updateLastMessageSeen(token: KeychainSwift().get("jwt") ?? "", chatId: sharedViewModel.inboxChats[index].id)
            socketViewModel.showNewMessageToOther(senderUsername: sharedViewModel.currentUser.username)
            socketViewModel.showUpdatedChatsInTheReceiver(receiver: sharedViewModel.inboxChats[index].chatMemberUsername)
            sharedViewModel.goToTheLastMessage.toggle()
        } catch {
            print(error)
            if error.asAFError?.responseCode == 401 {
                sharedViewModel.unauthorizedAccess()
            }
        }
    }
    
    func fetchMessagesTask(index: Int) {
        Task {
            await fetchMessages(index: index)
        }
    }
    
    func fetchMessages(index: Int) async {
        do {
            sharedViewModel.messages = try await repository.retrieveMessagesForAChat(token: KeychainSwift().get("jwt") ?? "", chatId: sharedViewModel.inboxChats[index].id)
            try await repository.updateLastMessageSeen(token: KeychainSwift().get("jwt") ?? "", chatId: sharedViewModel.inboxChats[index].id)
            sharedViewModel.numOfUnseenChats = try await repository.getNumOfUnseenChats(token: KeychainSwift().get("jwt") ?? "")
            showChat.toggle()
        } catch {
            print(error)
            if error.asAFError?.responseCode == 401 {
                sharedViewModel.unauthorizedAccess()
            }
        }
    }
}
