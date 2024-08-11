import SwiftUI

//component that shows the reader of posts when click in one post
struct PostReader: View {
    @ObservedObject var sharedViewModel: SharedViewModel
    @ObservedObject var socketViewModel: SocketViewModel
    @ObservedObject var profileViewModel: ProfileViewModel
    @ObservedObject var homeViewModel: HomeViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            ScrollViewReader { value in
                ScrollView(.vertical) {
                    ForEach(0..<sharedViewModel.profileUserPosts.count, id: \.self) { index in
                        Post(indexHome: 0, indexProfile: index, sharedViewModel: sharedViewModel, socketViewModel: socketViewModel, profileViewModel: profileViewModel, homeViewModel: homeViewModel)
                    }
                }
                .padding(.top, 20)
                .onAppear {
                    value.scrollTo(profileViewModel.selectedIndex, anchor: .top)
                }
            }
            
            if sharedViewModel.showOptions {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        withAnimation(.easeIn) {
                            sharedViewModel.showOptions = false
                        }
                    }
                
                PostOptions(index: profileViewModel.clickedPostIndex, profileViewModel: profileViewModel, sharedViewModel: sharedViewModel)
                    .frame(maxWidth: .infinity, maxHeight: 160)
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(radius: 10)
                    .offset(y: sharedViewModel.showOptions ? 360 : UIScreen.main.bounds.height)
                    .animation(.spring(dampingFraction: 0.8), value: sharedViewModel.showOptions)
                    .transition(.move(edge: .bottom))
            }
        }
    }
}
