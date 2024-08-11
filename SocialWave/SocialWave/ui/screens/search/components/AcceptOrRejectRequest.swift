import SwiftUI

//component that shows the two buttons of the accept or reject functionality a friend request
struct AcceptOrRejectRequest: View {
    @ObservedObject var searchViewModel: SearchViewModel
    let user: Int
    @State private var showDialogForAccept = false
    @State private var showDialogForReject = false
    @State private var selectedButton = 0
    
    var body: some View {
        HStack {
            Button {
                selectedButton = user
                showDialogForAccept = true
            } label: {
                Text("Accept")
                    .font(.headline)
                    .fontWeight(.medium)
                    .foregroundStyle(.green)
            }
            .shadow(color: Color.black.opacity(0.3), radius: 5, x: 1, y: 3)
            .alert(isPresented: $showDialogForAccept) {
                Alert(
                    title: Text("Accept Request"),
                    message: Text("Are you sure you want to accept the friend request?"),
                    primaryButton: .destructive(Text("Yes")) {
                        searchViewModel.acceptRequest(index: selectedButton)
                        searchViewModel.getBackButtonDetails()
                    },
                    secondaryButton: .cancel(Text("No"))
                )
            }
            
            Button {
                selectedButton = user
                showDialogForReject = true
            } label: {
                Text("Reject")
                    .font(.headline)
                    .fontWeight(.medium)
                    .foregroundStyle(.red)
            }
            .shadow(color: Color.black.opacity(0.3), radius: 5, x: 1, y: 3)
            .alert(isPresented: $showDialogForReject) {
                Alert(
                    title: Text("Reject Request"),
                    message: Text("Are you sure you want to reject the friend request?"),
                    primaryButton: .destructive(Text("Yes")) {
                        searchViewModel.rejectRequest(index: selectedButton)
                        searchViewModel.getBackButtonDetails()
                    },
                    secondaryButton: .cancel(Text("No"))
                )
            }
        }
    }
}
