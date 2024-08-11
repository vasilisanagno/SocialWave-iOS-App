import SwiftUI

//component that shows the errors accordingly the error code for different cases
struct ErrorTextsWithCodes: View {
    @Binding var errorCode: Int
    
    var body: some View {
        if errorCode == 1 {
            ErrorText(width: 132, height: 30, text: "Email is not valid.", red: 0.78)
        }
        else if errorCode == 2 {
            ErrorText(width: 329, height: 100, text: "Password must be at least 8 characters long and include at least 1 lowercase letter, 1 uppercase letter, 1 numeric digit, and 1 special character.", red: 0.78)
        }
        else if errorCode == 3 {
            ErrorText(width: 157, height: 30, text: "Incorrect OTP code!", red: 0.78)
        }
        else if errorCode == 4 {
            ErrorText(width: 220, height: 30, text: "Incorrect email or password!", red: 0.88)
        }
        else if errorCode == 5 {
            ErrorText(width: 285, height: 50, text: "Confirm Password must be the same with password.", red: 0.78)
        }
        else if errorCode == 6 {
            ErrorText(width: 260, height: 30, text: "Email or username already exists!", red: 0.78)
        }
        else if errorCode == 7 {
            ErrorText(width: 260, height: 30, text: "There is no account with this email!", red: 0.78)
        }
    }
}
