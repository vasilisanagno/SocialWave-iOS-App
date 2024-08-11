import Foundation
import SocketIO
import KeychainSwift

//view model for the socket communication
class SocketViewModel: ObservableObject {
    private let repository: NotificationRepository
    private let chatRepository: ChatRepository
    private let sharedViewModel: SharedViewModel
    var manager: SocketManager!
    @Published var socket: SocketIOClient!

    init(repository: NotificationRepository = DIContainer.shared.container.resolve(NotificationRepository.self)!,
         chatRepository: ChatRepository = DIContainer.shared.container.resolve(ChatRepository.self)!,
         sharedViewModel: SharedViewModel = DIContainer.shared.container.resolve(SharedViewModel.self)!) {
        self.sharedViewModel = sharedViewModel
        self.repository = repository
        self.chatRepository = chatRepository
        DispatchQueue.main.async {
            self.manager = SocketManager(socketURL: URL(string: Constants.BASE_URL)!, config: [
                .compress,
                .forceWebsockets(true),
                .secure(true)
            ])
            self.socket = self.manager.defaultSocket
            self.socket.connect()
            self.showNotification()
            self.showMessages()
            self.showUpdatedChats()
        }
    }
    
    //function that connects the user with the socket id
    func connectUser() {
        DispatchQueue.main.async {
            self.socket.emit("connectUser", self.sharedViewModel.currentUser.username)
        }
    }
    
    //function that sends notificatιοn to the other user
    func sendNotification(sender: String, receiver: String) {
        DispatchQueue.main.async {
            self.socket.emit("sendNotification", sender, receiver)
        }
    }
    
    //function to show updates in chats to the other user real time
    func showUpdatedChatsInTheReceiver(receiver: String) {
        DispatchQueue.main.async {
            self.socket.emit("showUpdatedChatsInTheReceiver", receiver)
        }
    }
    
    //function to listen the server so to change the notifications variable and the number of them
    func showNotification() {
        socket.on("showNotification") { data, _ in
            DispatchQueue.main.async {
                Task {
                    do {
                        if self.sharedViewModel.selectedTab == 4 {
                            self.sharedViewModel.notifications = try await self.repository.getNotifForTheCurrentUser(
                                token: KeychainSwift().get("jwt") ?? ""
                            )
                            self.clearUnseenNotifications(username: self.sharedViewModel.currentUser.username)
                        }
                        else {
                            self.sharedViewModel.numOfUnseenNotif = data[0] as! Int
                        }
                    } catch {
                        print(error)
                        if error.asAFError?.responseCode == 401 {
                            self.sharedViewModel.unauthorizedAccess()
                        }
                    }
                }
            }
        }
    }
    
    //function to clear unseen notifications from the server
    func clearUnseenNotifications(username: String) {
        DispatchQueue.main.async {
            self.socket.emit("clearUnseenNotifications", username)
        }
    }
    
    //function to create a chat in the server
    func createChat(usernameFirst: String, usernameSecond: String) {
        DispatchQueue.main.async {
            self.socket.emit("createChat", usernameFirst, usernameSecond)
        }
    }
    
    //function to show real time the new message to other
    func showNewMessageToOther(senderUsername: String) {
        DispatchQueue.main.async {
            self.socket.emit("showNewMessageToOther", senderUsername)
        }
    }
    
    //function that listen the server to update the messages when something new is coming in a chat from the other
    func showMessages() {
        socket.on("showMessages") { data, _ in
            DispatchQueue.main.async {
                Task {
                    do {
                        let chatId = self.sharedViewModel.inboxChats.first(where: { $0.chatMemberUsername == data[0] as! String })?.id
                        self.sharedViewModel.messages = try await self.chatRepository.retrieveMessagesForAChat(token: KeychainSwift().get("jwt") ?? "", chatId: chatId ?? "")
                        self.sharedViewModel.goToTheLastMessage.toggle()
                    } catch {
                        print(error)
                        if error.asAFError?.responseCode == 401 {
                            self.sharedViewModel.unauthorizedAccess()
                        }
                    }
                }
            }
        }
    }
    
    //function to listen the server to update the chats when something new is coming
    func showUpdatedChats() {
        socket.on("showUpdatedChats") { data, _ in
            DispatchQueue.main.async {
                Task {
                    do {
                        self.sharedViewModel.inboxChats = try await self.chatRepository.getInboxChats(
                            token: KeychainSwift().get("jwt") ?? ""
                        )
                        self.sharedViewModel.numOfUnseenChats = try await self.chatRepository.getNumOfUnseenChats(
                            token: KeychainSwift().get("jwt") ?? ""
                        )
                    } catch {
                        print(error)
                        if error.asAFError?.responseCode == 401 {
                            self.sharedViewModel.unauthorizedAccess()
                        }
                    }
                }
            }
        }
    }
}
