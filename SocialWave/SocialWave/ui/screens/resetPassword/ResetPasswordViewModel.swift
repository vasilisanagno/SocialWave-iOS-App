import Foundation

//view model that keeps the variable state across multiple views
//and communicates with the server to check the email existance in the database, to send otp to check the email
//and to change the password of an account
@MainActor
class ResetPasswordViewModel: ObservableObject {
    private let repository: AuthRepository
    private let sharedViewModel: SharedViewModel
    @Published var successEmail: Bool = false
    @Published var successOTP: Bool = false
    @Published var successUpdatePassword: Bool = false
    
    init(repository: AuthRepository = DIContainer.shared.container.resolve(AuthRepository.self)!,
         sharedViewModel: SharedViewModel = DIContainer.shared.container.resolve(SharedViewModel.self)!) {
        self.repository = repository
        self.sharedViewModel = sharedViewModel
    }
    
    func sendOTPClickButton() {
        Task {
            let isValidEmail = Validation.isValidEmail(sharedViewModel.email)
            if sharedViewModel.email.isEmpty {
                sharedViewModel.emailError = sharedViewModel.email.isEmpty
            }
            else if !isValidEmail {
                sharedViewModel.emailError = true
                sharedViewModel.errorCodeEmail = 1
            }
            else {
                sharedViewModel.showProgress = true
                try await checkEmailForResetPassword()
                sharedViewModel.showProgress = false
                if successEmail {
                    sharedViewModel.otp = Array(repeating: "", count: 6)
                }
            }
        }
    }
    
    func initVariables() {
        sharedViewModel.email = ""
        sharedViewModel.password = ""
        sharedViewModel.confirmPassword = ""
        sharedViewModel.passwordError = false
        sharedViewModel.confirmPasswordError = false
        sharedViewModel.emailError = false
        sharedViewModel.errorCodePassword = -1
        sharedViewModel.errorCodeConfirmPassword = -1
        sharedViewModel.errorCodeEmail = -1
        sharedViewModel.errorWrongEmail = false
        sharedViewModel.errorOTP = false
        sharedViewModel.errorCodeOTP = -1
    }
    
    func changePasswordClickButton() {
        Task {
            var check = false
            
            if sharedViewModel.password.isEmpty || sharedViewModel.confirmPassword.isEmpty {
                sharedViewModel.passwordError = sharedViewModel.password.isEmpty
                sharedViewModel.confirmPasswordError = sharedViewModel.confirmPassword.isEmpty
            }
            else {
                if !Validation.isValidPassword(sharedViewModel.password) {
                    sharedViewModel.passwordError = true
                    sharedViewModel.errorCodePassword = 2 //code for invalid password
                    check = true
                }
                if sharedViewModel.password != sharedViewModel.confirmPassword {
                    sharedViewModel.confirmPasswordError = true
                    sharedViewModel.errorCodeConfirmPassword = 5
                    check = true
                }
                if !check {
                    sharedViewModel.showProgress = true
                    try await updatePassword()
                    successUpdatePassword = true
                    sharedViewModel.showProgress = false
                }
            }
        }
    }
    
    func checkOTPClickButton() {
        Task {
            sharedViewModel.showProgress = true
            let response = try await repository.checkOTPOfTheUser(
                otp: Int64(sharedViewModel.otp.joined())!,
                email: sharedViewModel.email
            )
            successOTP = response.success
            if !successOTP {
                sharedViewModel.errorOTP = true
                sharedViewModel.errorCodeOTP = 3
            }
            sharedViewModel.showProgress = false
        }
    }
    
    private func checkEmailForResetPassword() async throws {
        do {
            let response = try await repository.checkEmailOfTheUser(
                email: sharedViewModel.email
            )
            successEmail = response.success
            if !successEmail {
                sharedViewModel.errorWrongEmail = true
                sharedViewModel.errorCodeWrongEmail = 7
                sharedViewModel.emailError = true
            }
        } catch {
            print(error)
        }
    }
    
    private func updatePassword() async throws {
        do {
            try await repository.changePasswordOfTheUser(
                email: sharedViewModel.email,
                password: sharedViewModel.password
            )
        } catch {
            print(error)
        }
    }
}
