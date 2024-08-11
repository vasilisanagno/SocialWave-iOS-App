import SwiftUI

//component that shows the list of comments to a post
struct CommentsList: View {
    @ObservedObject var sharedViewModel: SharedViewModel
    @ObservedObject var homeViewModel: HomeViewModel
    let index: Int
    @State private var showAlertDialog = false
    @State private var commentIndex = 0
    @State private var animatedIndex = 0
    private let animationDuration = 0.1
    @State private var animate = false
    private var animationScale: CGFloat {
        homeViewModel.likeClicked[animatedIndex] ? 0.7 : 1.3
    }
    
    var body: some View {
        LazyVStack(alignment: .leading, spacing: 12) {
            ForEach(0..<sharedViewModel.postComments.count, id: \.self) { i in
                VStack {
                    HStack {
                        CircularProfileImage(user: nil, notif: nil, chat: nil, comment: sharedViewModel.postComments[i], width: 40, height: 40, type: "comment")
                        
                        VStack(alignment: .leading) {
                            Text(sharedViewModel.postComments[i].username ?? "")
                                .font(.system(size: 14))
                                .bold()
                            Text(sharedViewModel.postComments[i].content)
                                .font(.system(size: 16))
                        }
                        .font(.footnote)
                        
                        Spacer()
                        
                        if sharedViewModel.currentUser.id == sharedViewModel.postComments[i].user {
                            Button {
                                commentIndex = i
                                showAlertDialog.toggle()
                            } label: {
                                Image(systemName: "trash")
                                    .imageScale(.small)
                                    .foregroundStyle(.red)
                            }
                        }
                        
                        VStack {
                            Button {
                                self.animate = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + self.animationDuration, execute: {
                                    self.animate = false
                                    animatedIndex = i
                                    homeViewModel.likeClicked[i].toggle()
                                    if homeViewModel.likeClicked[i] {
                                        homeViewModel.addCommentLikeTask(index: index, commentIndex: i)
                                    }
                                    else {
                                        homeViewModel.deleteCommentLikeTask(index: index, commentIndex: i)
                                    }
                                })
                            } label: {
                                Image(systemName: homeViewModel.likeClicked[i] ? "heart.fill" : "heart")
                                    .imageScale(.small)
                                    .foregroundStyle(homeViewModel.likeClicked[i] ? .red : .navyBlue)
                            }
                            Text("\(sharedViewModel.postComments[i].likes.count)")
                                .font(.footnote)
                                .padding(.top, 1)
                                .foregroundStyle(.navyBlue)
                        }
                    }
                    .padding(.top, 12)
                    .padding(.horizontal)
                    
                    Text(sharedViewModel.postComments[i].createdAt)
                        .font(.footnote)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 15)
                        .padding(.top, 1)
                        .foregroundStyle(.navyBlue)
                }
            }
            .padding(.bottom, 5)
            .foregroundStyle(.navyBlue)
            .alert(isPresented: $showAlertDialog) {
                Alert(
                    title: Text("Delete Comment"),
                    message: Text("Are you sure you want to delete your comment?"),
                    primaryButton: .destructive(Text("Yes")) {
                        homeViewModel.deleteCommentTask(index: index, commentIndex: commentIndex)
                    },
                    secondaryButton: .cancel(Text("No"))
                )
            }
        }
    }
}
