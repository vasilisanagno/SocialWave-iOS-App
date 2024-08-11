import SwiftUI

//component to check the otp that is right
struct CheckOTP: View {
    @ObservedObject var resetPasswordViewModel: ResetPasswordViewModel
    @ObservedObject var sharedViewModel: SharedViewModel
    
    var body: some View {
        if resetPasswordViewModel.successEmail {
            Text("OTP code is sent to your email.")
                .foregroundStyle(Color.navyBlue)
                .padding(.vertical, 16)
                .padding(.top, 7)
                .bold()
            
            OTPTextField(sharedViewModel: sharedViewModel)
                .disabled(resetPasswordViewModel.successOTP)
            
            if !resetPasswordViewModel.successOTP {
                // Show a circular progress indicator
                if sharedViewModel.showProgress {
                    SocialWaveCircularProgressBar()
                }
                else if sharedViewModel.errorOTP {
                    ErrorTextsWithCodes(errorCode: $sharedViewModel.errorCodeOTP)
                }
                
                //check OTP button
                SocialWaveButton(text: "Check OTP", showProgress: sharedViewModel.showProgress, onClick: {
                    resetPasswordViewModel.checkOTPClickButton()
                })
                .disabled(sharedViewModel.disabled)
            }
        }
    }
}
