import SwiftUI

//component that shows the details of the user (username and profile image)
struct UserInfo: View {
    let username: String
    let profileImage: String?
    
    var body: some View {
        //image and username
        HStack {
            if let imageData = Data(base64Encoded: profileImage ?? ""),
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


            Text(username)
                .font(.footnote)
                .fontWeight(.semibold)

            Spacer()
        }
        .padding(.leading, 15)
        .padding(.top, 10)
    }
}
