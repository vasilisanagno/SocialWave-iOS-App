import SwiftUI

//component to change the password with confirm password field
struct ChangePassword: View {
    @ObservedObject var resetPasswordViewModel: ResetPasswordViewModel
    @ObservedObject var sharedViewModel: SharedViewModel
    
    var body: some View {
        if resetPasswordViewModel.successOTP {
            VStack {
                //password secure field
                SocialWaveSecureField(placeholder: "Password", sharedViewModel: sharedViewModel)
                    .disabled(resetPasswordViewModel.successUpdatePassword)
                    .padding(.top, 15)
                
                //confirm password secure field
                SocialWaveSecureField(placeholder: "Confirm Password", sharedViewModel: sharedViewModel)
                    .disabled(resetPasswordViewModel.successUpdatePassword)
                
                if resetPasswordViewModel.successUpdatePassword {
                    Image("checkImage")
                        .foregroundStyle(.green)
                }
                //change password button
                SocialWaveButton(text: "Change Password", showProgress: sharedViewModel.showProgress, onClick: {
                    resetPasswordViewModel.changePasswordClickButton()
                })
                .disabled(resetPasswordViewModel.successUpdatePassword)
            }
        }
    }
}
