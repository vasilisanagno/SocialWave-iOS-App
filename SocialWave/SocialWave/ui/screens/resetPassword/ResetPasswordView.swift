import SwiftUI

//view that shows the screen of the reset password with all steps to reset the user his password
struct ResetPasswordView: View {
    @StateObject var resetPasswordViewModel: ResetPasswordViewModel = ResetPasswordViewModel()
    @ObservedObject var sharedViewModel: SharedViewModel
    
    init(sharedViewModel: SharedViewModel = DIContainer.shared.container.resolve(SharedViewModel.self)!) {
        self.sharedViewModel = sharedViewModel
        Design.hideNavigationBackground()
    }
    var body: some View {
        ZStack {
            SocialWaveBackground()
            VStack {
                ResetPasswordSteps(sharedViewModel: sharedViewModel, resetPasswordViewModel: resetPasswordViewModel)
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .padding(.leading,15)
            .padding(.trailing,15)
        }
        .onAppear {
            sharedViewModel.disabled = true
        }
        .toolbar {
            //back button
            ToolbarItem(placement: .topBarLeading) {
                ResetPasswordBackButton(sharedViewModel: sharedViewModel, resetPasswordViewModel: resetPasswordViewModel)
            }
        }
    }
}
