import SwiftUI

//component that the user can send again the request of the otp
struct OTPFoot: View {
    @ObservedObject var otpViewModel: OTPViewModel
    @ObservedObject var sharedViewModel: SharedViewModel
    
    var body: some View {
        HStack(spacing: 10) {
            Text("Didn't receive code?")
                .foregroundStyle(.white)
                .font(.system(size: 18))
                .bold()
            Button(action: {
                otpViewModel.requestAgainOTP()
            }) {
                Text("Request again")
                    .foregroundStyle(.navyBlue)
                    .font(.system(size: 18))
            }
            .disabled(sharedViewModel.disabled)
        }
        .font(.footnote)
        .padding(.bottom, 10)
    }
}
