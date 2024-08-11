import SwiftUI

//component that shows the list of the posts in a grid with 3 columns
struct GridPostList: View {
    @ObservedObject var sharedViewModel: SharedViewModel
    @ObservedObject var profileViewModel: ProfileViewModel
    
    private let gridItems: [GridItem] = [
        .init(.flexible(), spacing: 2), //spacing between the three items in a row
        .init(.flexible(), spacing: 2),
        .init(.flexible(), spacing: 2)
    ]
    var body: some View {
        LazyVGrid(columns: gridItems, spacing: 2) { //spacing between the rows
            ForEach(0..<sharedViewModel.profileUserPosts.count, id: \.self) { index in
                Image(uiImage: UIImage(data: Data(base64Encoded: sharedViewModel.profileUserPosts[index].images[0])!)!)
                    .resizable()
                    .scaledToFit()
                    .onTapGesture {
                        profileViewModel.selectedIndex = index
                        profileViewModel.postClicked.toggle()
                    }
            }
        }
        .padding(.top, -6)
    }
}
