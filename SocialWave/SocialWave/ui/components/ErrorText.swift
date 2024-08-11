import SwiftUI

//component that shows the error text with background color
struct ErrorText: View {
    let width: CGFloat, height: CGFloat, text: String, red: Double
    
    var body: some View {
        ZStack{
            HStack {
                Text(text)
                     .foregroundColor(Color(red: red, green: 0.2, blue: 0.2))
                     .padding(.horizontal)
                     .padding(.bottom, 3)
                     .padding(.top, text == "Incorrect OTP code!" ? 5 : 0)
                     .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 0)
               
                if(text != "Incorrect OTP code!") {
                    Spacer()
                }
           }
        }
    }
}
