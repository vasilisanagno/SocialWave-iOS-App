import SwiftUI

//component that shows the circular progress bar
struct SocialWaveCircularProgressBar: View {
    var body: some View {
        ProgressView()
            .tint(.navyBlue)
            .progressViewStyle(CircularProgressViewStyle())
            .padding(.top,5)
            .padding(.bottom, 10)
    }
}

#Preview {
    SocialWaveCircularProgressBar()
}
