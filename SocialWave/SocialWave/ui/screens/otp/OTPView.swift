import SwiftUI

//view that shows the otp verification for the email when the user wants to signup in the app
struct OTPView: View {
    @StateObject var otpViewModel = OTPViewModel()
    @ObservedObject var sharedViewModel: SharedViewModel
    
    init(sharedViewModel: SharedViewModel = DIContainer.shared.container.resolve(SharedViewModel.self)!) {
        self.sharedViewModel = sharedViewModel
    }
    var body: some View {
        ZStack{
            SocialWaveBackground()
            VStack {
                Text("Verify Email")
                    .font(.title2)
                    .foregroundStyle(Color.navyBlue)
                    .bold()
                    .padding()

                
                Text("OTP code is sent to your email and expires in 10 minutes.")
                    .foregroundStyle(Color.navyBlue)
                    .padding(.vertical, 16)
                    .padding(.top, 42)
                    .bold()
                
                OTPTextField(sharedViewModel: sharedViewModel)
                
                // Show a circular progress indicator
                if sharedViewModel.showProgress {
                    SocialWaveCircularProgressBar()
                }
                else if sharedViewModel.errorOTP {
                    ErrorTextsWithCodes(errorCode: $sharedViewModel.errorCodeOTP)
                }
                
                Spacer()
                
                //verify button
                SocialWaveButton(text: "Verify", showProgress: sharedViewModel.showProgress, onClick: {
                    otpViewModel.verifyClickButton()
                })
                .padding(.bottom, 20)
                .disabled(sharedViewModel.disabled)
                
                OTPFoot(otpViewModel: otpViewModel, sharedViewModel: sharedViewModel)
            }
            .onAppear {
                sharedViewModel.disabled = true
            }
        }
    }
}
