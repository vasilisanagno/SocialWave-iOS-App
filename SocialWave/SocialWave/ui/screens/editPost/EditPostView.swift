import SwiftUI

//view that shows the screen of the edit post caption of the current user's post
struct EditPostView: View {
    @ObservedObject var sharedViewModel: SharedViewModel
    let index: Int
    @Environment(\.dismiss) var dismiss
    @StateObject var editPostViewModel = EditPostViewModel()
    
    var body: some View {
        VStack {
            SocialWaveToolbar(sharedViewModel: sharedViewModel, title: "Edit Post", onCancel: {
                sharedViewModel.showOptions.toggle()
                sharedViewModel.caption = ""
                dismiss()
            }, onDone: {
                Task {
                    sharedViewModel.showProgress = true
                    try await editPostViewModel.editPostCaption(index: index, newCaption: sharedViewModel.caption)
                    sharedViewModel.showProgress = false
                    sharedViewModel.showOptions.toggle()
                    sharedViewModel.caption = ""
                    dismiss()
                }
            })
            
            //post images
            ImagesTabView(images: sharedViewModel.profileUserPosts[index].images)
            
            //edit profile info
            SocialWaveTextField(placeholder: "Caption", sharedViewModel: sharedViewModel)
                .padding(.leading, 10)
                .padding(.trailing, 10)
                .padding(.bottom, 10)
                .disabled(sharedViewModel.showProgress)
            
            if sharedViewModel.showProgress {
                SocialWaveCircularProgressBar()
                    .controlSize(.large)
                    .padding(.top, 50)
            }
            Spacer()
        }
        .onAppear {
            sharedViewModel.caption = sharedViewModel.profileUserPosts[index].text
        }
    }
}
