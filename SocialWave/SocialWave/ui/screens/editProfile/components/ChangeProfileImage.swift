import SwiftUI
import PhotosUI

//component that changes the profile image in the current user
struct ChangeProfileImage: View {
    @ObservedObject var sharedViewModel: SharedViewModel
    @ObservedObject var editProfileViewModel: EditProfileViewModel
    
    var body: some View {
        PhotosPicker(selection: $editProfileViewModel.selectedImage) {
            VStack {
                if let image = editProfileViewModel.profileImage {
                    image
                        .resizable()
                        .foregroundColor(.white)
                        .background(.gray)
                        .clipShape(Circle())
                        .frame(width: 150, height: 150)
                }
                else {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .clipShape(Circle())
                        .frame(width: 150, height: 150)
                        .foregroundStyle(.navyBlue)
                }

                Text("Edit Profile Picture")
                    .font(.headline)
                    .fontWeight(.semibold)
            }
        }
        .padding(.vertical, 8)
        .disabled(sharedViewModel.showProgress)
    }
}
