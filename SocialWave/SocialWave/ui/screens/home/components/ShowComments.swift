import SwiftUI

//component that shows the comments and the user could make a new comment to the post
struct ShowComments: View {
    @ObservedObject var sharedViewModel: SharedViewModel
    @ObservedObject var homeViewModel: HomeViewModel
    let index: Int
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            Text("Comments")
                .font(.headline)
                .fontWeight(.semibold)
                .padding(.top, 10)
                .foregroundStyle(.navyBlue)
            
            Divider()
                .frame(height: 0.8)
                .background(.navyBlue)
            
            if homeViewModel.commentProgressBar {
                SocialWaveCircularProgressBar()
                    .controlSize(.large)
                    .padding(.top, 300)
            }
            else {
                CommentsList(sharedViewModel: sharedViewModel, homeViewModel: homeViewModel, index: index)
            }
        }
        
        Divider()
            .frame(height: 0.8)
            .background(.navyBlue)
            .padding(.top, -8)
        
        HStack {
            CircularProfileImage(user: sharedViewModel.currentUser, notif: nil, chat: nil, comment: nil, width: 40, height: 40, type: "profile")
            
            TextField("Add Comment", text: $homeViewModel.commentText)
                .padding()
                .frame(height: 60)
                .autocapitalization(.none)
                .autocorrectionDisabled()
                .background(Color.white)
                .cornerRadius(8)
                .accentColor(.navyBlue)
            
            Button {
                homeViewModel.addCommentTask(index: index)
            } label: {
                Image(systemName: "paperplane.fill")
                    .imageScale(.large)
                    .foregroundStyle(.navyBlue)
            }
            .disabled(homeViewModel.commentText.isEmpty || homeViewModel.commentProgressBar)
        }
        .padding(.horizontal)
    }
}
