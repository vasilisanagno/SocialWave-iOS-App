import SwiftUI

//component that shows the button for upload a post in the home view
struct FloatingActionButton: View {
    @State private var newPostButtonClicked = false
    
    var body: some View {
        VStack {
            Spacer(minLength: 750)
            HStack {
                Spacer()
                Button(action: {
                    // Action for the button
                    newPostButtonClicked.toggle()
                }) {
                    Image(systemName: "plus.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 40, height: 40)
                        .foregroundStyle(.navyBlue.opacity(0.8))
                        .background(.white)
                        .clipShape(Circle())
                        .shadow(radius: 4)
                        .padding(.bottom, 150)
                }
            }
            .frame(height: 44, alignment: .center)
            .padding(.trailing, 20)
            .padding(.bottom, 20)
        }
        .fullScreenCover(isPresented: $newPostButtonClicked) {
            UploadPostView()
        }
    }
}

#Preview {
    FloatingActionButton()
}
