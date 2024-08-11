import SwiftUI

//component that removes the current profile image from the current user
struct RemoveCurrentImage: View {
    @ObservedObject var sharedViewModel: SharedViewModel
    @ObservedObject var editProfileViewModel: EditProfileViewModel
    
    var body: some View {
        Text("Remove current image")
            .font(.headline)
            .fontWeight(.semibold)
            .foregroundStyle(.red).opacity(editProfileViewModel.profileImage == nil ? 0.5 : 1)
            .onTapGesture {
                editProfileViewModel.profileImage = nil
                editProfileViewModel.uiImage = nil
                editProfileViewModel.selectedImage = nil
            }
            .disabled(editProfileViewModel.profileImage == nil || sharedViewModel.showProgress ? true : false)
    }
}
