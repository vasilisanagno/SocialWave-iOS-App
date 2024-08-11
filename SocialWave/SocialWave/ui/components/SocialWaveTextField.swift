import SwiftUI

//component that shows the text field of the app for general text fields
struct SocialWaveTextField: View {
    let placeholder: String
    @ObservedObject var sharedViewModel: SharedViewModel
    
    var body: some View {
        ZStack(alignment: .leading) {
            TextField(placeholder, text: placeholder == "Email" ? $sharedViewModel.email : (placeholder == "Username") ? $sharedViewModel.username : (placeholder == "Description") ? $sharedViewModel.description : (placeholder == "Caption") ? $sharedViewModel.caption : $sharedViewModel.fullname)
                .padding()
                .frame(height: 60)
                .autocapitalization(.none)
                .autocorrectionDisabled()
                .background(Color.white)
                .keyboardType(placeholder == "Email" ? .emailAddress : .default)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(((placeholder == "Email" && sharedViewModel.emailError) || (placeholder == "Username" && sharedViewModel.usernameError)) ? Color.red : .navyBlue, lineWidth: 1.5)
                )
                .accentColor(.navyBlue)
                .onChange(of: placeholder == "Email" ? sharedViewModel.email : sharedViewModel.username) { _, _ in
                    sharedViewModel.emailError = false
                    sharedViewModel.usernameError = false
                    sharedViewModel.passwordError = false
                    sharedViewModel.confirmPasswordError = false
                    sharedViewModel.errorLogin = false
                    sharedViewModel.errorSignup = false
                    sharedViewModel.errorWrongEmail = false
                    if(placeholder == "Email"){
                        sharedViewModel.errorCodeEmail = -1
                    }
                }
                
            if !(placeholder == "Email" ? sharedViewModel.email.isEmpty : (placeholder == "Username") ? sharedViewModel.username.isEmpty : (placeholder == "Description") ? sharedViewModel.description.isEmpty : (placeholder == "Caption") ? sharedViewModel.caption.isEmpty : sharedViewModel.fullname.isEmpty) {
                Text(placeholder)
                    .font(.system(size: 14))
                    .foregroundStyle(.navyBlue)
                    .offset(y: -16)
                    .padding(.leading, 20)
                    .padding(.bottom, 10)
                    .scaleEffect(0.8, anchor: .leading)
            }
        }
        .animation(.easeInOut, value: placeholder == "Email" ? sharedViewModel.email : (placeholder == "Username") ? sharedViewModel.username : (placeholder == "Description") ? sharedViewModel.description : (placeholder == "Caption") ? sharedViewModel.caption : sharedViewModel.fullname)
        .padding(.top,5)
        .padding(.bottom,5)
        
        if sharedViewModel.errorCodeEmail != -1 &&
           placeholder == "Email" &&
           sharedViewModel.emailError {
            ErrorTextsWithCodes(errorCode: $sharedViewModel.errorCodeEmail)
        }
    }
}
