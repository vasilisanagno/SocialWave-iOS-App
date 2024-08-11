import SwiftUI
import PhotosUI

//components that shows the images that selected the user to upload as a new post
struct PhotosSelection: View {
    @ObservedObject var uploadPostViewModel: UploadPostViewModel
    @ObservedObject var sharedViewModel: SharedViewModel
    
    var body: some View {
        PhotosPicker(
            selection:  $uploadPostViewModel.selectedItems,
            maxSelectionCount: 5,
            matching: .images,
            photoLibrary: .shared(),
            label: {
                Label {
                    Text("Select Images")
                        .font(.title3)
                        .fontWeight(.semibold)
                } icon: {
                    Image(systemName: "photo.on.rectangle.angled")
                        .imageScale(.medium)
                        .font(.title3)
                }
                .foregroundColor(.navyBlue)
                .shadow(color: Color.black.opacity(0.3), radius: 5, x: 1, y: 3)
            }
        )
        .disabled(sharedViewModel.showProgress)
        
        TabView {
            ForEach(uploadPostViewModel.postUIImages, id: \.id) { identifiableImage in
                Image(uiImage: identifiableImage.image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 350, height: 350)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
        .frame(width: 350, height: 350)
        .onAppear {
            Design.setUpAppearanceForUploadPost()
        }
    }
}
