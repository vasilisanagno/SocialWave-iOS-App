import SwiftUI

//component that shows the logo
struct ShowLogo: View {
    var body: some View {
        Image("logo")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 200, height: 200)
    }
}

#Preview {
    ShowLogo()
}
