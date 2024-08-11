import Foundation
import KeychainSwift
import SwiftUI

//view model that keeps the variable state across multiple views and communicates with the server
//to retrieve chats and friends that current user does not have yet chat and create/delete a chat
@MainActor
class InboxViewModel: ObservableObject {
    private let repository: ChatRepository
    private let sharedViewModel: SharedViewModel
    @Published var showNewMessage = false
    
    init(repository: ChatRepository = DIContainer.shared.container.resolve(ChatRepository.self)!,
         sharedViewModel: SharedViewModel = DIContainer.shared.container.resolve(SharedViewModel.self)!) {
        self.repository = repository
        self.sharedViewModel = sharedViewModel
    }
    
    //function that returns the filtered friends when the user search for friends to create a chat
    func filterFriends(searchText: String) -> [UserDetails] {
        if searchText.isEmpty {
            return sharedViewModel.friendsWithoutChatYetOriginal
        }
        else {
            return sharedViewModel.friendsWithoutChatYetOriginal.filter { $0.username.lowercased().hasPrefix(searchText.lowercased()) }
        }
    }
    
    func getChatsTask(backButton: Bool) {
        Task {
            await getChats(backButton: backButton)
        }
    }
    
    func getChats(backButton: Bool) async {
        do {
            sharedViewModel.showProgress = true
            if backButton {
                try await repository.updateLastMessageSeen(token: KeychainSwift().get("jwt") ?? "", chatId: sharedViewModel.inboxChats[sharedViewModel.selectedChat].id)
                sharedViewModel.numOfUnseenChats = try await repository.getNumOfUnseenChats(token: KeychainSwift().get("jwt") ?? "")
            }
            sharedViewModel.inboxChats = try await repository.getInboxChats(token: KeychainSwift().get("jwt") ?? "")
            sharedViewModel.showProgress = false
        } catch {
            print(error)
            if error.asAFError?.responseCode == 401 {
                sharedViewModel.unauthorizedAccess()
            }
        }
    }
    
    func getFriendsForNewChatsTask() {
        Task {
            await getFriendsForNewChats()
        }
    }
    
    func getFriendsForNewChats() async {
        do {
            showNewMessage.toggle()
            sharedViewModel.showProgress = true
            sharedViewModel.friendsWithoutChatYetOriginal = try await repository.getPossibleNewChatFriends(token: KeychainSwift().get("jwt") ?? "")
            sharedViewModel.friendsWithoutChatYet = sharedViewModel.friendsWithoutChatYetOriginal
            sharedViewModel.showProgress = false
        } catch {
            print(error)
            if error.asAFError?.responseCode == 401 {
                sharedViewModel.unauthorizedAccess()
            }
        }
    }
    
    func createChatTask(dismiss: DismissAction, index: Int) {
        Task {
            await createChat(index: index)
            dismiss()
        }
    }
    
    func createChat(index: Int) async {
        do {
            sharedViewModel.inboxChats = try await repository.createANewChat(token: KeychainSwift().get("jwt") ?? "", chatMember: sharedViewModel.friendsWithoutChatYet[index].id)
        } catch {
            print(error)
            if error.asAFError?.responseCode == 401 {
                sharedViewModel.unauthorizedAccess()
            }
        }
    }
    
    func deleteChatTask(index: Int) {
        Task {
            await deleteChat(index: index)
        }
    }
    
    func deleteChat(index: Int) async {
        do {
            sharedViewModel.showProgress = true
            sharedViewModel.inboxChats = try await repository.deleteAChat(token: KeychainSwift().get("jwt") ?? "", chatId: sharedViewModel.inboxChats[index].id)
            sharedViewModel.numOfUnseenChats = try await repository.getNumOfUnseenChats(token: KeychainSwift().get("jwt") ?? "")
            sharedViewModel.showProgress = false
        } catch {
            print(error)
            if error.asAFError?.responseCode == 401 {
                sharedViewModel.unauthorizedAccess()
            }
        }
    }
}
