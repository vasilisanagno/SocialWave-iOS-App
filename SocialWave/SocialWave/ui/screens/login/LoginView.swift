import SwiftUI

//view that shows the screen of the login process
struct LoginView: View {
    @ObservedObject private var sharedViewModel: SharedViewModel
    @StateObject private var loginViewModel: LoginViewModel = LoginViewModel()
    
    init(sharedViewModel: SharedViewModel = DIContainer.shared.container.resolve(SharedViewModel.self)!) {
        self.sharedViewModel = sharedViewModel
    }
    var body: some View {
        NavigationStack(path: $sharedViewModel.startPath) {
            ZStack {
                SocialWaveBackground()
                
                VStack {
                    LoginForm(loginViewModel: loginViewModel, sharedViewModel: sharedViewModel)
                    
                    LoginFoot(loginViewModel: loginViewModel, sharedViewModel: sharedViewModel)
                }
                .frame(maxHeight: .infinity, alignment: .top)
                .padding(.top,100)
                .padding(.leading,15)
                .padding(.trailing,15)
            }
            .navigationDestination(for: String.self) { destination in
                switch destination {
                    case "Login":
                        LoginView()
                            .navigationBarBackButtonHidden(true)
                    
                    case "SignUp":
                        SignupView()
                            .navigationBarBackButtonHidden(true)
                    
                    case "OTP" :
                        OTPView()
                            .navigationBarBackButtonHidden(true)
                    
                    case "ResetPassword":
                        ResetPasswordView()
                            .navigationBarBackButtonHidden(true)
                    
                    default:
                        EmptyView()
                }
            }
        }
    }
}
