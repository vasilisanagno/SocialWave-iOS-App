import SwiftUI

//component that shows the view when the user wants to create a new chat with a friend
struct NewMessage: View {
    @ObservedObject var sharedViewModel: SharedViewModel
    @ObservedObject var socketViewModel: SocketViewModel
    @ObservedObject var inboxViewModel: InboxViewModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            NewMessageToolbar(dismiss: dismiss)
            
            NewMessageSearch(sharedViewModel: sharedViewModel, inboxViewModel: inboxViewModel)
            Divider()
                .frame(width: 400, height: 1.2)
                .background(.navyBlue)
            
            FriendsList(sharedViewModel: sharedViewModel, socketViewModel: socketViewModel, inboxViewModel: inboxViewModel, dismiss: dismiss)
        }
    }
}
