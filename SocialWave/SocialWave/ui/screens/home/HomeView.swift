import SwiftUI

//view that shows the screen of the home view with all the posts of the friends of the current user
struct HomeView: View {
    @ObservedObject var sharedViewModel: SharedViewModel
    @ObservedObject var socketViewModel: SocketViewModel
    @ObservedObject var profileViewModel: ProfileViewModel
    @ObservedObject var homeViewModel: HomeViewModel
    
    var body: some View {
        ZStack {
            SocialWaveBackground()
            if sharedViewModel.showProgress {
                SocialWaveCircularProgressBar()
                    .controlSize(.large)
            }
            else {
                ScrollViewReader { value in
                    ScrollView(.vertical, showsIndicators: false) {
                        LazyVStack(spacing: 28) {
                            if sharedViewModel.friendsPosts.isEmpty && sharedViewModel.suggestedFriends.count != 0 {
                                //if there are no posts, show suggestions at the top
                                FriendsSuggestionSideScroll(sharedViewModel: sharedViewModel, profileViewModel: profileViewModel)
                            }
                            ForEach(0..<sharedViewModel.friendsPosts.count, id: \.self) { index in
                                Post(indexHome: index, indexProfile: 0, sharedViewModel: sharedViewModel, socketViewModel: socketViewModel, profileViewModel: profileViewModel, homeViewModel: homeViewModel)
                                
                                //insert suggestions after 2 posts
                                if index == 1 && sharedViewModel.suggestedFriends.count != 0 {
                                    FriendsSuggestionSideScroll(sharedViewModel: sharedViewModel, profileViewModel: profileViewModel)
                                }
                            }
                            
                            //if there are fewer than 2 posts but at least 1, show suggestions at the end
                            if sharedViewModel.friendsPosts.count > 0 && sharedViewModel.friendsPosts.count < 2  && sharedViewModel.suggestedFriends.count != 0 {
                                FriendsSuggestionSideScroll(sharedViewModel: sharedViewModel, profileViewModel: profileViewModel)
                            }
                        }
                        .padding(.top, 40)
                        .padding(.bottom, 40)
                    }
                    .refreshable {
                        if !sharedViewModel.showProgress {
                            Task {
                                try await homeViewModel.fetchPosts()
                            }
                        }
                    }
                    .onChange(of: sharedViewModel.firstHomePost) {
                        if sharedViewModel.firstHomePost {
                            sharedViewModel.firstHomePost = false
                            value.scrollTo(0, anchor: .zero)
                        }
                    }
                }
                .onAppear {
                    UIRefreshControl.appearance().tintColor = UIColor.navyBlue
                }
            }
        }
        .onAppear {
            Task {
                try await homeViewModel.fetchPosts()
                socketViewModel.connectUser()
            }
        }
    }
}
