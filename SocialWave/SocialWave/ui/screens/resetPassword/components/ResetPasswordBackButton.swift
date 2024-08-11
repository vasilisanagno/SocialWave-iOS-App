import SwiftUI

//component that shows the back button in the reset password view
struct ResetPasswordBackButton: View {
    @ObservedObject var sharedViewModel: SharedViewModel
    @ObservedObject var resetPasswordViewModel: ResetPasswordViewModel
    
    var body: some View {
        HStack(spacing: 5) {
            Image(systemName: "chevron.left")
                .imageScale(.large)
                .onTapGesture {
                    resetPasswordViewModel.initVariables()
                    sharedViewModel.startPath.removeLast()
                }
                .foregroundStyle(Color.navyBlue)
            Text("Log In")
                .foregroundStyle(Color.navyBlue)
                .font(.system(size: 18))
                .onTapGesture {
                    resetPasswordViewModel.initVariables()
                    sharedViewModel.startPath.removeLast()
                }
        }
    }
}
