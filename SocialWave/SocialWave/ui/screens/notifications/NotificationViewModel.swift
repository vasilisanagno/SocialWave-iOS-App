import Foundation
import KeychainSwift

//view model that keeps the variable state across multiple views and communicates with the server
//to retrieve notifications and delete all the notifications
@MainActor
class NotificationViewModel: ObservableObject {
    private let repository: NotificationRepository
    private let sharedViewModel: SharedViewModel
    private let socketViewModel: SocketViewModel
    
    init(repository: NotificationRepository = DIContainer.shared.container.resolve(NotificationRepository.self)!,
         sharedViewModel: SharedViewModel = DIContainer.shared.container.resolve(SharedViewModel.self)!,
         socketViewModel: SocketViewModel = DIContainer.shared.container.resolve(SocketViewModel.self)!) {
        self.repository = repository
        self.sharedViewModel = sharedViewModel
        self.socketViewModel = socketViewModel
    }
    
    func getNotificationsTask() {
        Task {
            await getNotifications()
        }
    }
    
    func getNotifications() async {
        do {
            sharedViewModel.numOfUnseenNotif = 0
            sharedViewModel.showProgress = true
            sharedViewModel.notifications = try await repository.getNotifForTheCurrentUser(
                token: KeychainSwift().get("jwt") ?? ""
            )
            socketViewModel.clearUnseenNotifications(username: sharedViewModel.currentUser.username)
            sharedViewModel.showProgress = false
        } catch {
            print(error)
            if error.asAFError?.responseCode == 401 {
                sharedViewModel.unauthorizedAccess()
            }
        }
    }
    
    func deleteNotificationsTask() {
        Task {
            await deleteNotifications()
        }
    }
    
    private func deleteNotifications() async {
        do {
            sharedViewModel.showProgress = true
            try await repository.deleteNotifOfTheCurrentUser(
                token: KeychainSwift().get("jwt") ?? ""
            )
            socketViewModel.clearUnseenNotifications(username: sharedViewModel.currentUser.username)
            sharedViewModel.notifications = []
            sharedViewModel.showProgress = false
        } catch {
            print(error)
            if error.asAFError?.responseCode == 401 {
                sharedViewModel.unauthorizedAccess()
            }
        }
    }
}
