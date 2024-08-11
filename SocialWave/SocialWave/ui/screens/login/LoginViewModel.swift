import Foundation
import KeychainSwift

//view model that keeps the variable state across multiple views
//and communicates with the server to login the user to the main part of the app
//again after the login success get the num of unseen notifications and chats
@MainActor
class LoginViewModel: ObservableObject {
    private let authRepository: AuthRepository
    private let notificationRepository: NotificationRepository
    private let chatRepository: ChatRepository
    private let sharedViewModel: SharedViewModel
    private var success: Bool = false
    
    init(authRepository: AuthRepository = DIContainer.shared.container.resolve(AuthRepository.self)!,
         notificationRepository: NotificationRepository = DIContainer.shared.container.resolve(NotificationRepository.self)!,
         chatRepository: ChatRepository = DIContainer.shared.container.resolve(ChatRepository.self)!,
         sharedViewModel: SharedViewModel = DIContainer.shared.container.resolve(SharedViewModel.self)!) {
        self.authRepository = authRepository
        self.notificationRepository = notificationRepository
        self.chatRepository = chatRepository
        self.sharedViewModel = sharedViewModel
    }
    
    func loginClickButton() {
        Task {
            if sharedViewModel.email.isEmpty || sharedViewModel.password.isEmpty {
                sharedViewModel.emailError = sharedViewModel.email.isEmpty
                sharedViewModel.passwordError = sharedViewModel.password.isEmpty
            }
            else {
                sharedViewModel.showProgress = true
                try await makeLogin()
                sharedViewModel.showProgress = false
                if !success {
                    sharedViewModel.emailError = true
                    sharedViewModel.passwordError = true
                    sharedViewModel.errorLogin = true
                    sharedViewModel.errorCodeLogin = 4 //code for invalid login
                }
                else if !sharedViewModel.password.isEmpty && !sharedViewModel.email.isEmpty {
                    await getNumOfUnseenNotifications()
                    await getNumOfUnseenChats()
                    sharedViewModel.loginSuccess = true
                }
            }
        }
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
    
    func forgotPasswordClick() {
        initVariables()
        sharedViewModel.startPath.append("ResetPassword")
    }
    
    func signupClick() {
        initVariables()
        sharedViewModel.startPath.append("SignUp")
    }
    
    func initVariables() {
        sharedViewModel.errorCodeEmail = -1
        sharedViewModel.errorCodePassword = -1
        sharedViewModel.emailError = false
        sharedViewModel.passwordError = false
        sharedViewModel.email = ""
        sharedViewModel.password = ""
    }
    
    private func makeLogin() async throws {
        do {
            (self.success, sharedViewModel.currentUser) = try await authRepository.login(
                email: sharedViewModel.email,
                password: sharedViewModel.password
            )
        } catch {
            print(error)
        }
    }
}
