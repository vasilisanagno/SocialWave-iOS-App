import SwiftUI

//view that shows the screen of the signup process
struct SignupView: View {
    @ObservedObject private var sharedViewModel: SharedViewModel
    @StateObject var signupViewModel: SignupViewModel = SignupViewModel()
    
    init(sharedViewModel: SharedViewModel = DIContainer.shared.container.resolve(SharedViewModel.self)!) {
        self.sharedViewModel = sharedViewModel
        Design.hideNavigationBackground()
    }

    var body: some View {
        ZStack {
            SocialWaveBackground()
            
            SignupForm(signupViewModel: signupViewModel, sharedViewModel: sharedViewModel)
        }
        .toolbar {
            //back button
            ToolbarItem(placement: .topBarLeading) {
                SignupBackButton(signupViewModel: signupViewModel, sharedViewModel: sharedViewModel)
            }
        }
    }
}
