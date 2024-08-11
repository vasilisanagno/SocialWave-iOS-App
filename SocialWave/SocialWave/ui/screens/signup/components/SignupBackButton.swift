import SwiftUI

//component that shows the back button in the signup screen
struct SignupBackButton: View {
    @ObservedObject var signupViewModel: SignupViewModel
    @ObservedObject var sharedViewModel: SharedViewModel
    
    var body: some View {
        HStack(spacing: 5) {
            Image(systemName: "chevron.left")
                .imageScale(.large)
                .onTapGesture {
                    signupViewModel.initVariables()
                    sharedViewModel.startPath.removeLast()
                }
                .foregroundStyle(Color.navyBlue)
            Text("Log In")
                .foregroundStyle(Color.navyBlue)
                .font(.system(size: 18))
                .onTapGesture {
                    signupViewModel.initVariables()
                    sharedViewModel.startPath.removeLast()
                }
        }
    }
}
