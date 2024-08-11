import SwiftUI

//component to check the email that is right
struct CheckEmail: View {
    @ObservedObject var resetPasswordViewModel: ResetPasswordViewModel
    @ObservedObject var sharedViewModel: SharedViewModel
    
    var body: some View {
        //email text field
        SocialWaveTextField(placeholder: "Email", sharedViewModel: sharedViewModel)
            .disabled(resetPasswordViewModel.successEmail)
            .overlay (
                resetPasswordViewModel.successEmail ? Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(.green)
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .trailing)
                    .padding(.trailing, 10) : nil
            )
        
        if !resetPasswordViewModel.successEmail {
            // Show a circular progress indicator
            if sharedViewModel.showProgress {
                SocialWaveCircularProgressBar()
            }
            else if sharedViewModel.errorWrongEmail {
                ErrorTextsWithCodes(errorCode: $sharedViewModel.errorCodeWrongEmail)
            }
            
            //Send OTP button
            SocialWaveButton(text: "Send OTP", showProgress: sharedViewModel.showProgress, onClick: {
                resetPasswordViewModel.sendOTPClickButton()
            })
        }
    }
}
