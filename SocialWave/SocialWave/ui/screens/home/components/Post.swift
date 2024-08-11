import SwiftUI

//component that shows the post and details of this
struct Post: View {
    let indexHome: Int
    let indexProfile: Int
    @ObservedObject var sharedViewModel: SharedViewModel
    @ObservedObject var socketViewModel: SocketViewModel
    @ObservedObject var profileViewModel: ProfileViewModel
    @ObservedObject var homeViewModel: HomeViewModel
    
    var body: some View {
        ZStack {
            Color(.white).opacity(0.9)
            
            VStack {
                //shows user's photo profile and username
                HStack {
                    UserInfo(
                        username: (sharedViewModel.selectedTab == 5 || sharedViewModel.selectedTab == 2) && profileViewModel.postClicked ? sharedViewModel.profileUser.username : sharedViewModel.friendsPosts[indexHome].username,
                        profileImage:(sharedViewModel.selectedTab == 5 || sharedViewModel.selectedTab == 2) && profileViewModel.postClicked ? sharedViewModel.profileUser.profileImage : sharedViewModel.friendsPosts[indexHome].profileImage
                    )
                    Spacer()
                    if (sharedViewModel.selectedTab == 5 || sharedViewModel.selectedTab == 2) && sharedViewModel.profileUser.username == sharedViewModel.currentUser.username {
                        Image(systemName: "ellipsis")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .padding(.top, 10)
                            .padding(.trailing, 15)
                            .onTapGesture {
                                profileViewModel.clickedPostIndex = indexProfile
                                sharedViewModel.showOptions.toggle()
                            }
                    }
                }
                
                //post images
                ImagesTabView(images: (sharedViewModel.selectedTab == 5 || sharedViewModel.selectedTab == 2) && profileViewModel.postClicked ? sharedViewModel.profileUserPosts[indexProfile].images : sharedViewModel.friendsPosts[indexHome].images)
                    .onAppear {
                        UIPageControl.appearance().currentPageIndicatorTintColor = .white
                        UIPageControl.appearance().pageIndicatorTintColor = UIColor.white.withAlphaComponent(0.4)
                    }
                
                //shows like and comment buttons, and the number of likes in the post
                LikeAndCommentBar(sharedViewModel: sharedViewModel, socketViewModel: socketViewModel, homeViewModel: homeViewModel, likes:   (sharedViewModel.selectedTab == 5 || sharedViewModel.selectedTab == 2) && profileViewModel.postClicked ? sharedViewModel.profileUserPosts[indexProfile].likes.count : sharedViewModel.friendsPosts[indexHome].likes.count, indexHome: indexHome, indexProfile: indexProfile)
                
                //shows the caption of the post and the time it uploaded
                CaptionAndTimeInfo(
                    username: (sharedViewModel.selectedTab == 5 || sharedViewModel.selectedTab == 2) && profileViewModel.postClicked ? sharedViewModel.profileUser.username : sharedViewModel.friendsPosts[indexHome].username,
                    caption: (sharedViewModel.selectedTab == 5 || sharedViewModel.selectedTab == 2) && profileViewModel.postClicked ? sharedViewModel.profileUserPosts[indexProfile].text : sharedViewModel.friendsPosts[indexHome].text,
                    createdAt: (sharedViewModel.selectedTab == 5 || sharedViewModel.selectedTab == 2) && profileViewModel.postClicked ? sharedViewModel.profileUserPosts[indexProfile].createdAt : sharedViewModel.friendsPosts[indexHome].createdAt
                )
            }
        }
        .cornerRadius(20)
        .shadow(radius: 5)
        .padding(.top, 5)
        .padding(.leading, 10)
        .padding(.trailing, 10)
    }
}
