import SwiftUI

//component that shows the cards that has the details of the users that are suggested
struct FriendSuggestionCard: View {
    @ObservedObject var sharedViewModel: SharedViewModel
    @ObservedObject var profileViewModel: ProfileViewModel
    let index: Int
    @State private var addFriendClicked = false
    
    var body: some View {
        ZStack {
            Color(.white).opacity(0.9)
            
            VStack {
                if let imageData = Data(base64Encoded: sharedViewModel.suggestedFriends[index].profileImage ?? ""),
                   let image = UIImage(data: imageData) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                        .padding(.top, 10)
                        .padding(.bottom, 10)
                } else {
                    // Provide a fallback view for when the image data isn't valid
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .clipShape(Circle())
                        .frame(width: 50, height: 50)
                        .foregroundStyle(.navyBlue)
                        .padding(.top, 10)
                        .padding(.bottom, 10)
                }
                
                Text(sharedViewModel.suggestedFriends[index].username)
                    .padding(.bottom, 10)
                
                if sharedViewModel.suggestedFriends[index].fullname != nil {
                    Text(sharedViewModel.suggestedFriends[index].fullname!)
                        .padding(.bottom, 10)
                }
                
                Button(action: {
                    sharedViewModel.suggestedFriends[index].pendingOrNot?.toggle()
                    sharedViewModel.suggestedFriend = sharedViewModel.suggestedFriends[index]
                    profileViewModel.sendOrUnsendRequest()
                }) {
                    Text(!sharedViewModel.suggestedFriends[index].pendingOrNot! ? "Add Friend" : "Pending")
                        .font(.subheadline)
                        .foregroundStyle(.white)
                        .padding()
                        .frame(width: 120, height: 30)
                        .background(
                            RoundedRectangle(cornerRadius: 10.0)
                                .fill(Color.navyBlue)
                                .shadow(color: Color.black.opacity(0.6), radius: 5, x: 1, y: 3)
                        )
                }
                .padding(.bottom, 5)
                .disabled(profileViewModel.processOnBoard)
            }
        }
        .frame(width: 150, height: 200)
        .cornerRadius(20)
        .shadow(radius: 5)
        .padding(.top, 5)
    }
}
