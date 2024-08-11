import SwiftUI

//component that shows the friends that made a like
struct ShowLikes: View {
    @ObservedObject var sharedViewModel: SharedViewModel
    @ObservedObject var homeViewModel: HomeViewModel
    
    var body: some View {
        ScrollView {
            Text("Likes")
                .font(.headline)
                .fontWeight(.semibold)
                .padding(.top, 10)

            Divider()
                .frame(height: 0.8)
                .background(.navyBlue)
            
            if homeViewModel.likeProgressBar {
                SocialWaveCircularProgressBar()
                    .controlSize(.large)
                    .padding(.top, 300)
            }
            else {
                LazyVStack(alignment: .leading, spacing: 12) {
                    ForEach(0..<sharedViewModel.friendsLikedPost.count, id: \.self) { user in
                        HStack {
                            if let imageData = Data(base64Encoded: sharedViewModel.friendsLikedPost[user].profileImage ?? ""),
                               let image = UIImage(data: imageData) {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 40, height: 40)
                                    .clipShape(Circle())
                            } else {
                                // Provide a fallback view for when the image data isn't valid
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 40, height: 40)
                                    .clipShape(Circle())
                            }
                            
                            VStack(alignment: .leading) {
                                Text(sharedViewModel.friendsLikedPost[user].username)
                                    .fontWeight(.semibold)
                                    .font(.system(size: 16))
                                if sharedViewModel.friendsLikedPost[user].fullname != nil {
                                    Text(sharedViewModel.friendsLikedPost[user].fullname!)
                                        .font(.system(size: 14))
                                }
                            }
                            .font(.footnote)
                        }
                        .padding(.top, 12)
                        .padding(.horizontal)
                    }
                }
                .padding(.bottom, 8)
                .foregroundStyle(.navyBlue)
            }
        }
    }
}
