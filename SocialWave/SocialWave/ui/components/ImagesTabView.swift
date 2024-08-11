import SwiftUI

//components that shows the images with the horizontal scroll tab view
struct ImagesTabView: View {
    let images: [String]
    
    var body: some View {
        TabView {
            ForEach(images, id: \.self) { base64String in
                if let imageData = Data(base64Encoded: base64String),
                   let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .frame(width: 350, height: 350)
                        .clipped()
                        .cornerRadius(20)
                } else {
                    Text("Image not available")
                        .frame(width: 350, height: 350)
                        .background(Color.gray)
                        .cornerRadius(20)
                }
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
        .frame(width: 350, height: 350)
    }
}
