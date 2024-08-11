import SwiftUI

//component that shows the text field of the app for secure fields like password or confirm-password
struct SocialWaveSecureField: View {
    let placeholder: String
    @State private var isSecure: Bool = true
    @ObservedObject var sharedViewModel: SharedViewModel
    
    var body: some View {
        ZStack(alignment: .leading) {
            ZStack(alignment: .trailing) {
                if isSecure {
                    SecureField(placeholder, text: placeholder == "Password" ? $sharedViewModel.password : $sharedViewModel.confirmPassword)
                        .padding()
                        .frame(height: 60)
                        .autocapitalization(.none)
                        .autocorrectionDisabled()
                        .background(Color.white)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(((placeholder == "Password" && sharedViewModel.passwordError) || (placeholder == "Confirm Password" && sharedViewModel.confirmPasswordError)) ? Color.red : Color.navyBlue, lineWidth: 1.5)
                        )
                        .accentColor(Color.navyBlue)
                        .onChange(of: placeholder == "Password" ? sharedViewModel.password : sharedViewModel.confirmPassword) { _,_ in
                            sharedViewModel.emailError = false
                            sharedViewModel.usernameError = false
                            sharedViewModel.passwordError = false
                            sharedViewModel.confirmPasswordError = false
                            sharedViewModel.errorLogin = false
                            sharedViewModel.errorSignup = false
                            if placeholder == "Password" {
                                sharedViewModel.errorCodePassword = -1
                            }
                            else {
                                sharedViewModel.errorCodeConfirmPassword = -1
                            }
                        }
                    
                } else {
                    TextField(placeholder, text: placeholder == "Password" ? $sharedViewModel.password : $sharedViewModel.confirmPassword)
                        .padding()
                        .frame(height: 60)
                        .autocapitalization(.none)
                        .autocorrectionDisabled()
                        .background(Color.white)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(((placeholder == "Password" && sharedViewModel.passwordError) || (placeholder == "Confirm Password" && sharedViewModel.confirmPasswordError)) ? Color.red : Color.navyBlue, lineWidth: 1.5)
                        )
                        .accentColor(Color.navyBlue)
                        .onChange(of: placeholder == "Password" ? sharedViewModel.password : sharedViewModel.confirmPassword) { _,_ in
                            sharedViewModel.emailError = false
                            sharedViewModel.usernameError = false
                            sharedViewModel.passwordError = false
                            sharedViewModel.confirmPasswordError = false
                            sharedViewModel.errorLogin = false
                            sharedViewModel.errorSignup = false
                            if placeholder == "Password" {
                                sharedViewModel.errorCodePassword = -1
                            }
                            else {
                                sharedViewModel.errorCodeConfirmPassword = -1
                            }
                        }
                }
                
                Button(action: {
                    isSecure = !isSecure
                }, label: {
                    Image(systemName: !isSecure ? "eye.slash" : "eye")
                        .foregroundStyle(.navyBlue)
                        .padding(.trailing,10)
                        .frame(height: 40)
                        .background(Color.white)
                })
            }
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(((placeholder == "Password" && sharedViewModel.passwordError) || (placeholder == "Confirm Password" && sharedViewModel.confirmPasswordError)) ? Color.red : Color.navyBlue, lineWidth: 1.5)
            )
            .onAppear {
                isSecure = true
            }
            
            
            if !(placeholder == "Password" ? sharedViewModel.password.isEmpty : sharedViewModel.confirmPassword.isEmpty) {
                Text(placeholder)
                    .font(.system(size: 14))
                    .foregroundStyle(Color.navyBlue)
                    .offset(y: -16)
                    .padding(.leading, 20)
                    .padding(.bottom, 10)
                    .scaleEffect(0.8, anchor: .leading)
            }
        }
        .animation(.easeInOut, value: placeholder == "Password" ? sharedViewModel.password : sharedViewModel.confirmPassword)
        .padding(.top,5)
        .padding(.bottom,5)
    
        if sharedViewModel.errorCodePassword != -1 &&
           placeholder == "Password" &&
           sharedViewModel.passwordError {
            ErrorTextsWithCodes(errorCode: $sharedViewModel.errorCodePassword)
        }
        if sharedViewModel.errorCodeConfirmPassword != -1 && 
           placeholder == "Confirm Password" &&
           sharedViewModel.confirmPasswordError {
            ErrorTextsWithCodes(errorCode: $sharedViewModel.errorCodeConfirmPassword)
        }
    }
}
