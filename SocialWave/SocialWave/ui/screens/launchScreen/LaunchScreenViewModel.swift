import Foundation
import KeychainSwift

//view model that keeps the variable state across multiple views
//and communicates with the server to verify the user and get the num of unseen notifications and chats
@MainActor
class LaunchScreenViewModel: ObservableObject {
    private let authRepository: AuthRepository
    private let notificationRepository: NotificationRepository
    private let chatRepository: ChatRepository
    private let sharedViewModel: SharedViewModel
    
    init(authRepository: AuthRepository = DIContainer.shared.container.resolve(AuthRepository.self)!,
         notificationRepository: NotificationRepository = DIContainer.shared.container.resolve(NotificationRepository.self)!,
         chatRepository: ChatRepository = DIContainer.shared.container.resolve(ChatRepository.self)!,
         sharedViewModel: SharedViewModel = DIContainer.shared.container.resolve(SharedViewModel.self)!) {
        self.authRepository = authRepository
        self.chatRepository = chatRepository
        self.notificationRepository = notificationRepository
        self.sharedViewModel = sharedViewModel
    }
    
    func getNumOfUnseenNotifications() async {
        do {
            sharedViewModel.numOfUnseenNotif = try await notificationRepository.getUnseenNotifForTheCurrentUser(
                token: KeychainSwift().get("jwt") ?? ""
            )
        } catch {
            print(error)
            if error.asAFError?.responseCode == 401 {
                sharedViewModel.unauthorizedAccess()
            }
        }
    }
    
    func getNumOfUnseenChats() async {
        do {
            sharedViewModel.numOfUnseenChats = try await chatRepository.getNumOfUnseenChats(
                token: KeychainSwift().get("jwt") ?? ""
            )
        } catch {
            print(error)
            if error.asAFError?.responseCode == 401 {
                sharedViewModel.unauthorizedAccess()
            }
        }
    }
    
    func verifyUserForAutoLogin() async throws {
        do {
            let keychain = KeychainSwift()
            let token = keychain.get("jwt")
            if(token != nil) {
                sharedViewModel.currentUser = try await authRepository.verifyUser(token: token!)
                await getNumOfUnseenNotifications()
                await getNumOfUnseenChats()
                sharedViewModel.autoLogin = true
            }
            else {
                sharedViewModel.autoLogin = false
            }
        } catch {
            sharedViewModel.autoLogin = false
            print(error)
        }
    }
}
