import SwiftUI

//component that shows each notification according the type of the notification
struct Notification: View {
    @ObservedObject var sharedViewModel: SharedViewModel
    let index: Int
    
    var body: some View {
        VStack {
            HStack {
                CircularProfileImage(user: nil, notif: sharedViewModel.notifications[index], chat: nil, comment: nil, width: 40, height: 40, type: "notif")
                    .padding(.leading, 15)
                    .padding(.top, index == 0 ? 10 : 0)
                Spacer()
                VStack(alignment: .center) {
                    Text(sharedViewModel.notifications[index].notificationType == "like" ? "\(sharedViewModel.notifications[index].senderUsername) liked one of your posts." : sharedViewModel.notifications[index].notificationType == "comment" ? "\(sharedViewModel.notifications[index].senderUsername) commented on one of your posts." :
                            "\(sharedViewModel.notifications[index].senderUsername) has sent you a friend request." )
                        .font(.subheadline)
                        .foregroundStyle(.navyBlue)
                        .padding(.leading, -20)
                        .padding(.top, index == 0 ? 10 : 0)
                }
                Spacer()
                if sharedViewModel.notifications[index].notificationType != "request" {
                    VStack(alignment: .trailing) {
                        Image(uiImage: UIImage(data: Data(base64Encoded: sharedViewModel.notifications[index].postImage!)!)!)
                            .resizable()
                            .frame(width: 40, height: 40)
                            .clipped()
                            .cornerRadius(5)
                            .padding(.trailing, 15)
                            .padding(.leading, -15)
                            .padding(.top, index == 0 ? 10 : 0)
                    }
                }
            }
            Text(sharedViewModel.notifications[index].createdAt)
                .font(.footnote)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 15)
                .padding(.top, 1)
                .padding(.bottom, 10)
                .foregroundStyle(.navyBlue)
        }
    }
}
