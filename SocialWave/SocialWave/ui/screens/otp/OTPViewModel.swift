import Foundation

//view model that keeps the variable state across multiple views
//and communicates with the server to verify the otp
@MainActor
class OTPViewModel: ObservableObject {
    private let repository: AuthRepository
    private let sharedViewModel: SharedViewModel
    private var success: Bool = true
    
    init(repository: AuthRepository = DIContainer.shared.container.resolve(AuthRepository.self)!,
         sharedViewModel: SharedViewModel = DIContainer.shared.container.resolve(SharedViewModel.self)!) {
        self.repository = repository
        self.sharedViewModel = sharedViewModel
    }
    
    func verifyClickButton() {
        Task {
            sharedViewModel.showProgress = true
            try await verifyNewUser()
            sharedViewModel.showProgress = false
            if success {
                initVariables()
                sharedViewModel.startPath.append("Login")
            }
            else {
                sharedViewModel.errorOTP = true
                sharedViewModel.errorCodeOTP = 3
            }
        }
    }
    
    func initVariables() {
        sharedViewModel.username = ""
        sharedViewModel.password = ""
        sharedViewModel.confirmPassword = ""
        sharedViewModel.email = ""
        sharedViewModel.emailError = false
        sharedViewModel.passwordError = false
        sharedViewModel.confirmPasswordError = false
        sharedViewModel.errorCodeOTP = -1
        sharedViewModel.errorOTP = false
    }
    
    private func verifyNewUser() async throws {
        do {
            let response = try await repository.signupAfterOTPCheck(
                otp: Int64(sharedViewModel.otp.joined())!,
                email: sharedViewModel.email,
                username: sharedViewModel.username,
                password: sharedViewModel.password
            )
            success = response.success
        } catch {
            print(error)
        }
    }
    
    func requestAgainOTP() {
        Task {
            sharedViewModel.disabled = true
            _ = try await repository.signupWithOTPFirst(
                email: sharedViewModel.email,
                username: sharedViewModel.username,
                process: "requestAgain"
            )
            sharedViewModel.disabled = false
        }
    }
}
