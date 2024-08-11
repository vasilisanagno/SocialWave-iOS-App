import SwiftUI

//component that is shown when two users are not friends and the posts are not shown
struct NotFriendsYet: View {
    @ObservedObject var sharedViewModel: SharedViewModel
    @ObservedObject var profileViewModel: ProfileViewModel
    
    var body: some View {
        VStack {
            Text("You are not friends yet!")
                .foregroundStyle(.navyBlue)
                .padding(.top, 50)
                .padding(.bottom, 5)
                .font(.headline)
            
            Button(action: {
                profileViewModel.sendOrUnsendRequest()
            }) {
                Text((sharedViewModel.selectedTab == 2 ? !sharedViewModel.pendingOrNotFromSearchTab : !sharedViewModel.pendingOrNotFromProfileTab) ? "Add Friend" : "Pending")
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
            .disabled(profileViewModel.processOnBoard)
        }
    }
}
