import SwiftUI

//component that shows the background color of the app
struct SocialWaveBackground: View {
    var body: some View {
        RadialGradient(gradient: Gradient(colors: [Color.blue.opacity(0.5), Color.purple]), center: .center, startRadius: 120, endRadius: 500)
            .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    SocialWaveBackground()
}
