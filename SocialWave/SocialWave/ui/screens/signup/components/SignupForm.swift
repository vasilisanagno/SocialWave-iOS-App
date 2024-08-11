import SwiftUI

//component that shows the signup form
struct SignupForm: View {
    @ObservedObject var signupViewModel: SignupViewModel
    @ObservedObject var sharedViewModel: SharedViewModel
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                //logo of the app
                ShowLogo()
                
                //email text field
                SocialWaveTextField(placeholder: "Email", sharedViewModel: sharedViewModel)
                
                //username text field
                SocialWaveTextField(placeholder: "Username", sharedViewModel: sharedViewModel)
                
                //password secure field
                SocialWaveSecureField(placeholder: "Password", sharedViewModel: sharedViewModel)
                
                //confirm password secure field
                SocialWaveSecureField(placeholder: "Confirm Password", sharedViewModel: sharedViewModel)
                
                // Show a circular progress indicator
                if sharedViewModel.showProgress {
                    SocialWaveCircularProgressBar()
                }
                else if sharedViewModel.errorSignup {
                    ErrorTextsWithCodes(errorCode: $sharedViewModel.errorCodeSignup)
                }
                
                //signup button
                SocialWaveButton(text: "Sign Up", showProgress: sharedViewModel.showProgress, onClick: {
                    signupViewModel.signupClickButton()
                })
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .padding(.leading,15)
            .padding(.trailing,15)
        }
        
    }
}
