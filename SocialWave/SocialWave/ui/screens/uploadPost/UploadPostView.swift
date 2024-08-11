import SwiftUI

//view that shows the screen of upload a new post in the current user's profile
struct UploadPostView: View {
    @StateObject var uploadPostViewModel = UploadPostViewModel() //thelei init???
    @ObservedObject private var sharedViewModel: SharedViewModel
    @State private var currentIndex = 0
    @Environment(\.dismiss) var dismiss
    
    init(sharedViewModel: SharedViewModel = DIContainer.shared.container.resolve(SharedViewModel.self)!) {
        self.sharedViewModel = sharedViewModel
    }
    var body: some View {
        VStack {
            SocialWaveToolbar(sharedViewModel: sharedViewModel, title: "New Post", onCancel: {
                sharedViewModel.caption = ""
                dismiss()
            },
             onDone: {
                if uploadPostViewModel.postUIImages.count != 0 {
                    Task {
                        sharedViewModel.showProgress = true
                        try await uploadPostViewModel.uploadPost()
                        sharedViewModel.showProgress = false
                        sharedViewModel.caption = ""
                        dismiss()
                    }
                }
            })
            
            PhotosSelection(uploadPostViewModel: uploadPostViewModel, sharedViewModel: sharedViewModel)
            
            CaptionField(uploadPostViewModel: uploadPostViewModel, sharedViewModel: sharedViewModel)
        }

    }
}
