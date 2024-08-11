import Foundation

//view model that keeps the variable state across multiple views, initialize variables
//and communicates with the server to make the signup process with the send of the otp for email verification
@MainActor
class SignupViewModel: ObservableObject {
    private let repository: AuthRepository
    private let sharedViewModel: SharedViewModel
    private var success: Bool = true
    
    init(repository: AuthRepository = DIContainer.shared.container.resolve(AuthRepository.self)!,
         sharedViewModel: SharedViewModel = DIContainer.shared.container.resolve(SharedViewModel.self)!) {
        self.repository = repository
        self.sharedViewModel = sharedViewModel
    }
    
    func signupClickButton() {
        Task {
            var check: Bool = false
            
            if sharedViewModel.email.isEmpty || sharedViewModel.username.isEmpty || sharedViewModel.password.isEmpty || sharedViewModel.confirmPassword.isEmpty {
                sharedViewModel.emailError = sharedViewModel.email.isEmpty
                sharedViewModel.usernameError = sharedViewModel.username.isEmpty
                sharedViewModel.passwordError = sharedViewModel.password.isEmpty
                sharedViewModel.confirmPasswordError = sharedViewModel.confirmPassword.isEmpty
                check = true
            }
            else{
                if !Validation.isValidEmail(sharedViewModel.email) {
                    sharedViewModel.emailError = true
                    sharedViewModel.errorCodeEmail = 1 //code for invalid email
                    check = true
                }
                if !Validation.isValidPassword(sharedViewModel.password) {
                    sharedViewModel.passwordError = true
                    sharedViewModel.errorCodePassword = 2 //code for invalid password
                    check = true
                }
                if sharedViewModel.password != sharedViewModel.confirmPassword {
                    // Handle case where passwords do not match
                    sharedViewModel.confirmPasswordError = true
                    sharedViewModel.errorCodeConfirmPassword = 5 //code for not matching passwords
                    check = true
                }
            }
            
            if !check {
                sharedViewModel.showProgress = true
                try await beginSignup()
                sharedViewModel.showProgress = false
                if success {
                    sharedViewModel.otp = Array(repeating: "", count: 6)
                    sharedViewModel.startPath.append("OTP")
                }
                else {
                    sharedViewModel.errorSignup = true
                    sharedViewModel.emailError = true
                    sharedViewModel.usernameError = true
                    sharedViewModel.errorCodeSignup = 6
                }
            }
        }
    }
    
    func initVariables() {
        sharedViewModel.usernameError = false
        sharedViewModel.emailError = false
        sharedViewModel.passwordError = false
        sharedViewModel.confirmPasswordError = false
        sharedViewModel.errorSignup = false
        sharedViewModel.email = ""
        sharedViewModel.username = ""
        sharedViewModel.password = ""
        sharedViewModel.confirmPassword = ""
        sharedViewModel.errorCodeSignup = -1
        sharedViewModel.errorCodePassword = -1
        sharedViewModel.errorCodeEmail = -1
        sharedViewModel.errorCodeConfirmPassword = -1
    }
    
    private func beginSignup() async throws {
        do {
            let response = try await repository.signupWithOTPFirst(
                email: sharedViewModel.email,
                username: sharedViewModel.username,
                process: "signup"
            )
            success = response.success
        } catch {
            print(error)
        }
    }
}
