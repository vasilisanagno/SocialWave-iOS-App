import SwiftUI

//component that shows the foot of the login screen
struct LoginFoot: View {
    @ObservedObject var loginViewModel: LoginViewModel
    @ObservedObject var sharedViewModel: SharedViewModel
    
    var body: some View {
        //navigation for sign up if user does not have an account
        HStack(spacing: 10) {
            Text("Don't have an account?")
                .foregroundStyle(.white)
                .font(.system(size: 18))
                .bold()
            NavigationLink(value: sharedViewModel.startPath){
                Text("Sign Up")
                    .foregroundColor(.navyBlue)
                    .font(.system(size: 18))
                    .onTapGesture {
                        loginViewModel.signupClick()
                    }
            }
        }
        .font(.footnote)
    }
}
