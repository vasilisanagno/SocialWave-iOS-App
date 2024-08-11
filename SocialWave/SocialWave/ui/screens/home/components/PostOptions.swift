import SwiftUI

//component that shows the options(edit post and delete post) of the post if the user is current 
struct PostOptions: View {
    let index: Int
    @ObservedObject var profileViewModel: ProfileViewModel
    @ObservedObject var sharedViewModel: SharedViewModel
    @State private var showAlert = false
    @State private var showEditPost = false
    
    var body: some View {
        VStack(spacing: 10) {
            Text("Options")
                .font(.headline)
                .fontWeight(.semibold)
                .padding(.top, 10)

            Divider()
                .frame(height: 0.8)
                .background(.navyBlue)
            
            
            Button {
                showEditPost.toggle()
            } label: {
                Text("Edit Post")
                    .font(.subheadline)
                    .fontWeight(.semibold)
            }
            .shadow(color: Color.black.opacity(0.3), radius: 5, x: 1, y: 3)
            .fullScreenCover(isPresented: $showEditPost, content: {
                EditPostView(sharedViewModel: sharedViewModel, index: index)
            })
            
            Button {
                showAlert.toggle()
            } label: {
                Text("Delete Post")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.red)
            }
            .shadow(color: Color.black.opacity(0.3), radius: 5, x: 1, y: 3)
            .alert(isPresented: $showAlert) {
                   Alert(
                       title: Text("Delete Post"),
                       message: Text("Are you sure you want to delete your post?"),
                       primaryButton: .destructive(Text("Yes")) {
                           Task {
                               try await profileViewModel.deletePost(postId: sharedViewModel.profileUserPosts[index].id)
                               sharedViewModel.showOptions.toggle()
                           }
                       },
                       secondaryButton: .cancel(Text("No"))
                   )
               }
            
            Spacer()
        }

    }
}
