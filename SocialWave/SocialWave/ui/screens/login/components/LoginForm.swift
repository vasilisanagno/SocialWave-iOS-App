import SwiftUI

//component that shows the login form to signin in the app
struct LoginForm: View {
    @ObservedObject var loginViewModel: LoginViewModel
    @ObservedObject var sharedViewModel: SharedViewModel
    
    var body: some View {
        //logo of the app
        ShowLogo()

        //email text field
        SocialWaveTextField(placeholder: "Email", sharedViewModel: sharedViewModel)
        
        //password secure field
        SocialWaveSecureField(placeholder: "Password", sharedViewModel: sharedViewModel)
        
        // Show a circular progress indicator
        if sharedViewModel.showProgress {
            SocialWaveCircularProgressBar()
        }
        else if sharedViewModel.errorLogin {
            ErrorTextsWithCodes(errorCode: $sharedViewModel.errorCodeLogin)
        }
        //navigation for forgot password if user forgot the password
        HStack {
            Spacer()
            NavigationLink(value: sharedViewModel.startPath){
                Text("Forgot Password?")
                    .foregroundStyle(.navyBlue)
                    .font(.system(size: 18)).onTapGesture {
                        loginViewModel.forgotPasswordClick()
                    }
            }
        }
        .padding(.trailing, 6)
        
        //login button
        SocialWaveButton(text: "Log In", showProgress: sharedViewModel.showProgress,onClick: {
            loginViewModel.loginClickButton()
        })
        
        Spacer()
    }
}
