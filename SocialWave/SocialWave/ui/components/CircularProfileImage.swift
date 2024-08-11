import SwiftUI

//component that shows the circular profile image
struct CircularProfileImage: View {
    let user: UserDetails?
    let notif: NotificationDetails?
    let chat: ChatDetails?
    let comment: CommentDetails?
    let width: CGFloat
    let height: CGFloat
    let type: String
    var body: some View {
        if let imageData = Data(base64Encoded: (type == "profile" ? user?.profileImage : type == "notif" ? notif?.senderProfile : type=="comment" ? comment?.profileImage : chat?.chatMemberProfileImage ?? "") ?? ""),
           let image = UIImage(data: imageData) {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .frame(width: width, height: height)
                .clipShape(Circle())
        }
        else {
            Image(systemName: "person.circle.fill")
                .resizable()
                .scaledToFill()
                .frame(width: width, height: height)
                .clipShape(Circle())
                .foregroundStyle(.navyBlue)
        }
    }
}
