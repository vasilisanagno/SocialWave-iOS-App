import SwiftUI

//view that shows the screen of the edit profile of the current user
struct EditProfileView: View {
    @ObservedObject var sharedViewModel: SharedViewModel
    @Environment(\.dismiss) var dismiss
    @StateObject var editProfileViewModel = EditProfileViewModel()

    var body: some View {
        VStack {
            SocialWaveToolbar(sharedViewModel: sharedViewModel, title: "Edit Profile", onCancel: {
                dismiss()
            }, onDone: {
                Task {
                    sharedViewModel.showProgress = true
                    try await editProfileViewModel.editUserData()
                    sharedViewModel.showProgress = false
                    if sharedViewModel.profileUser.profileImage != nil {
                        editProfileViewModel.profileImage = Image(
                            uiImage: UIImage(data: Data(base64Encoded: sharedViewModel.profileUser.profileImage!)!)!
                        )
                    }
                    sharedViewModel.fullname = sharedViewModel.currentUser.fullname ?? ""
                    sharedViewModel.description = sharedViewModel.currentUser.description ?? ""
                    dismiss()
                }
            })

            //edit profile pic
            ChangeProfileImage(sharedViewModel: sharedViewModel, editProfileViewModel: editProfileViewModel)
            
            RemoveCurrentImage(sharedViewModel: sharedViewModel, editProfileViewModel: editProfileViewModel)
            
            //edit profile info
            VStack {
                SocialWaveTextField(placeholder: "Fullname", sharedViewModel: sharedViewModel)
                    .padding(.leading, 10)
                    .padding(.trailing, 10)
                    .padding(.bottom, 10)
                    .disabled(sharedViewModel.showProgress)
                
                SocialWaveTextField(placeholder: "Description", sharedViewModel: sharedViewModel)
                    .padding(.leading, 10)
                    .padding(.trailing, 10)
                    .padding(.bottom, 10)
                    .disabled(sharedViewModel.showProgress)
            }
            if sharedViewModel.showProgress {
                SocialWaveCircularProgressBar()
                    .controlSize(.large)
                    .padding(.top, 50)
            }
            Spacer()
        }
        .onAppear {
            editProfileViewModel.initializeVariables()
        }
    }
}
