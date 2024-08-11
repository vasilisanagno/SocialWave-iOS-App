import SwiftUI

//component that shows the trash icon button to delete a friend
struct DeleteFriend: View {
    @ObservedObject var searchViewModel: SearchViewModel
    let user: Int
    @State private var showDialogForDeleteFriend = false
    @State private var selectedButton = 0
    
    var body: some View {
        Image(systemName: "trash")
            .resizable()
            .scaledToFit()
            .frame(width: 20,height: 20)
            .foregroundStyle(.red)
            .onTapGesture {
                selectedButton = user
                showDialogForDeleteFriend = true
            }
            .alert(isPresented: $showDialogForDeleteFriend) {
                Alert(
                    title: Text("Delete Friend"),
                    message: Text("Are you sure you want to delete your friend?"),
                    primaryButton: .destructive(Text("Yes")) {
                        searchViewModel.deleteFriend(index: selectedButton)
                        searchViewModel.getBackButtonDetails()
                    },
                    secondaryButton: .cancel(Text("No"))
                )
            }
    }
}
