import SwiftUI
import PhotosUI

//component that shows the settings of the profile log out or delete account
struct Settings: View {
    @ObservedObject var profileViewModel: ProfileViewModel
    @State private var showAlert = false
    
    var body: some View {
        VStack(spacing: 10) {
            Text("Settings")
                .font(.headline)
                .fontWeight(.semibold)
                .padding(.top, 10)

            Divider()
                .frame(height: 0.8)
                .background(.navyBlue)
            
            
            Button {
                profileViewModel.logOut()
            } label: {
                Text("Log Out")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.red)
            }
            .shadow(color: Color.black.opacity(0.3), radius: 5, x: 1, y: 3)
            
            Button {
                showAlert.toggle()
            } label: {
                Text("Delete Account")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.red)
            }
            .shadow(color: Color.black.opacity(0.3), radius: 5, x: 1, y: 3)
            .alert(isPresented: $showAlert) {
                   Alert(
                       title: Text("Delete Account"),
                       message: Text("Are you sure you want to delete your account?"),
                       primaryButton: .destructive(Text("Yes")) {
                           profileViewModel.deleteUser()
                       },
                       secondaryButton: .cancel(Text("No"))
                   )
               }
            
            Spacer()
        }
    }
}
