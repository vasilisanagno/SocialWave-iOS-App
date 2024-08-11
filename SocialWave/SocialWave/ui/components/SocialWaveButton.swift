import SwiftUI

//component that shows the button of the app
struct SocialWaveButton: View {
    let text: String
    let showProgress: Bool
    var onClick: () -> Void
    
    var body: some View {
        Button(action: {
            onClick()
        }) {
            Text(text)
                .font(.headline)
                .foregroundStyle(.white)
                .padding()
                .frame(width: 180, height: 50)
                .background(
                    RoundedRectangle(cornerRadius: 30.0)
                        .fill(Color.navyBlue)
                        .shadow(color: Color.black.opacity(0.6), radius: 5, x: 1, y: 3)
                )
        }
        .padding(.top,text == "Sign Up" ? 15 : 10)
        .disabled(showProgress)
    }
}
