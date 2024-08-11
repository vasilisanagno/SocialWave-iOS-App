import SwiftUI

//component that shows the friend suggestions with the horizontal scroll
struct FriendsSuggestionSideScroll: View {
    @ObservedObject var sharedViewModel: SharedViewModel
    @ObservedObject var profileViewModel: ProfileViewModel
    
    var body: some View {
        VStack {
            Divider()
                .frame(height: 1.2)
                .background(.navyBlue)
            
            Text("Suggested for You")
                .padding(.bottom, 5)
                .padding(.top, 5)
                .foregroundStyle(.navyBlue)
                .font(.title)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(0..<sharedViewModel.suggestedFriends.count, id: \.self) { index in
                        FriendSuggestionCard(sharedViewModel: sharedViewModel, profileViewModel: profileViewModel, index: index)
                    }
                }
                .padding()
            }
            Divider()
                .frame(height: 1.2)
                .background(.navyBlue)
        }
    }
}
