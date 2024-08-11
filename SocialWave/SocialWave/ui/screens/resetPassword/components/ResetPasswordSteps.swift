import SwiftUI

//component that shows the steps to reset password a user
struct ResetPasswordSteps: View {
    @ObservedObject var sharedViewModel: SharedViewModel
    @ObservedObject var resetPasswordViewModel: ResetPasswordViewModel
    
    var body: some View {
        VStack{
            Text("Reset Password")
                .font(.title2)
                .foregroundStyle(Color.navyBlue)
                .bold()
                .padding()
            
            CheckEmail(resetPasswordViewModel: resetPasswordViewModel, sharedViewModel: sharedViewModel)
            
            CheckOTP(resetPasswordViewModel: resetPasswordViewModel, sharedViewModel: sharedViewModel)
            
            ChangePassword(resetPasswordViewModel: resetPasswordViewModel, sharedViewModel: sharedViewModel)
        }
    }
}
