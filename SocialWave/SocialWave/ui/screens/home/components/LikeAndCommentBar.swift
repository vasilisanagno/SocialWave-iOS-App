import SwiftUI

//component that shows and has functionality about the likes and comments
struct LikeAndCommentBar: View {
    @ObservedObject var sharedViewModel: SharedViewModel
    @ObservedObject var socketViewModel: SocketViewModel
    @ObservedObject var homeViewModel: HomeViewModel
    let likes: Int
    let indexHome: Int
    let indexProfile: Int
    @State private var showLikesClicked = false
    @State private var showCommentsClicked = false
    @State private var likeClicked = false
    private let animationDuration = 0.1
    private var animationScale: CGFloat {
        likeClicked ? 0.7 : 1.3
    }
    @State private var animate = false
    
    var body: some View {
        //action buttons
        HStack(spacing: 16) {
            Button {
                self.animate = true
                DispatchQueue.main.asyncAfter(deadline: .now() + self.animationDuration, execute: {
                    self.animate = false
                    self.likeClicked.toggle()
                    if likeClicked {
                        Task {
                            try await homeViewModel.addLike(userId: sharedViewModel.currentUser.id, postId: sharedViewModel.selectedTab == 5 || sharedViewModel.selectedTab == 2 ? sharedViewModel.profileUserPosts[indexProfile].id : sharedViewModel.friendsPosts[indexHome].id, index: sharedViewModel.selectedTab == 5 || sharedViewModel.selectedTab == 2 ? indexProfile : indexHome)
                            socketViewModel.sendNotification(sender: sharedViewModel.currentUser.username, receiver: sharedViewModel.selectedTab == 5 || sharedViewModel.selectedTab == 2 ? sharedViewModel.profileUserPosts[indexProfile].username : sharedViewModel.friendsPosts[indexHome].username)
                        }
                    }
                    else {
                        Task {
                            try await homeViewModel.deleteLike(userId: sharedViewModel.currentUser.id, postId: sharedViewModel.selectedTab == 5 || sharedViewModel.selectedTab == 2 ? sharedViewModel.profileUserPosts[indexProfile].id : sharedViewModel.friendsPosts[indexHome].id, index: sharedViewModel.selectedTab == 5 || sharedViewModel.selectedTab == 2 ? indexProfile : indexHome)
                        }
                    }
                })
            } label: {
                Image(systemName: likeClicked ? "heart.fill" : "heart")
                    .imageScale(.large)
                    .foregroundStyle(likeClicked ? .red : .navyBlue)
            }
            
            Button {
                showCommentsClicked.toggle()
                homeViewModel.retrievePostCommentsTask(index: sharedViewModel.selectedTab == 5 || sharedViewModel.selectedTab == 2 ? indexProfile : indexHome)
            } label: {
                Image(systemName: "message")
                    .imageScale(.large)
                    .foregroundStyle(.navyBlue)
            }
            .sheet(isPresented: $showCommentsClicked, onDismiss: {
                homeViewModel.commentText = ""
            }, content: {
                ShowComments(sharedViewModel: sharedViewModel, homeViewModel: homeViewModel, index: sharedViewModel.selectedTab == 5 || sharedViewModel.selectedTab == 2 ? indexProfile : indexHome)
            })
            
            Spacer()
        }
        .padding(.leading, 15)
        .padding(.top, 4)
        .foregroundStyle(.black)
        .onAppear {
            for i in 0..<((sharedViewModel.selectedTab == 5 || sharedViewModel.selectedTab == 2) && sharedViewModel.profileUserPosts.count != 0 ? sharedViewModel.profileUserPosts[indexProfile].likes.count : sharedViewModel.friendsPosts[indexHome].likes.count) {
                if (((sharedViewModel.selectedTab == 5 || sharedViewModel.selectedTab == 2) && sharedViewModel.profileUserPosts.count != 0) && sharedViewModel.profileUserPosts[indexProfile].likes[i] == sharedViewModel.currentUser.id) || (sharedViewModel.selectedTab == 1 && sharedViewModel.friendsPosts[indexHome].likes[i] == sharedViewModel.currentUser.id) {
                    likeClicked = true
                }
            }
        }
        
        //likes label
        Text("\(likes) likes")
            .font(.footnote)
            .fontWeight(.semibold)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 15)
            .padding(.top, 1)
            .onTapGesture {
                if likes > 0 {
                    homeViewModel.retrievePostLikesTask(index: sharedViewModel.selectedTab == 5 || sharedViewModel.selectedTab == 2 ? indexProfile : indexHome)
                    showLikesClicked.toggle()
                }
            }
            .sheet(isPresented: $showLikesClicked, content: {
                ShowLikes(sharedViewModel: sharedViewModel, homeViewModel: homeViewModel)
            })
    }
}
