import SwiftUI

//component that shows the toolbar in many views
struct SocialWaveToolbar: View {
    @ObservedObject var sharedViewModel: SharedViewModel
    var title: String
    var onCancel: () -> Void
    var onDone: () -> Void
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    onCancel()
                }) {
                    Text("Cancel")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .padding(.top, 10)
                }
                .disabled(sharedViewModel.showProgress)

                Spacer()

                Text(title)
                    .bold()
                    .font(.system(size: 20))
                    .padding(.top, 10)

                Spacer()

                Button(action: {
                    onDone()
                }) {
                    Text("Done")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .padding(.top, 10)
                }
                .disabled(sharedViewModel.showProgress)
            }
            .padding(.horizontal)

            Divider()
                .frame(width: 400, height: 1.2)
                .background(Color.navyBlue)

        }
        .padding(.bottom, 8)
    }
}
