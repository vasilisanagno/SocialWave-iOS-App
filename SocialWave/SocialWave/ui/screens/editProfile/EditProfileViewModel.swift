import Foundation
import PhotosUI
import SwiftUI
import KeychainSwift

//view model that keeps the variable state across multiple views, initializes varibales in the launch of the screen
//and communicates with the server to edit the profile details for the current user
@MainActor
class EditProfileViewModel: ObservableObject {
    private let repository: UserRepository
    private let sharedViewModel: SharedViewModel
    @Published var selectedImage: PhotosPickerItem? {
        didSet { Task { await loadImage(fromItem: selectedImage) } }
    }
    @Published var profileImage: Image?
    @Published var uiImage: UIImage?
    
    
    init(repository: UserRepository = DIContainer.shared.container.resolve(UserRepository.self)!,
         sharedViewModel: SharedViewModel = DIContainer.shared.container.resolve(SharedViewModel.self)!) {
        self.repository = repository
        self.sharedViewModel = sharedViewModel
    }
    
    func loadImage(fromItem item: PhotosPickerItem?) async {
        guard let item = item else { return }

        guard let data = try? await item.loadTransferable(type: Data.self) else { return }
        self.uiImage = UIImage(data: data)
        if self.uiImage == nil {
            return
        }
        self.profileImage = Image(uiImage: uiImage!)
    }
    
    func editUserData() async throws {
        do {
            sharedViewModel.currentUser = try await repository.editUser(
                username: sharedViewModel.currentUser.username,
                fullname: sharedViewModel.fullname,
                description: sharedViewModel.description,
                token: KeychainSwift().get("jwt") ?? "",
                profileImage: self.uiImage ?? UIImage()
            )
            sharedViewModel.profileUser = sharedViewModel.currentUser
        } catch {
            print(error)
            if error.asAFError?.responseCode == 401 {
                sharedViewModel.unauthorizedAccess()
            }
        }
    }
    
    func initializeVariables() {
        if sharedViewModel.profileUser.profileImage != nil {
            profileImage = Image(
                uiImage: UIImage(data: Data(base64Encoded: sharedViewModel.profileUser.profileImage!)!)!
            )
            uiImage = UIImage(data: Data(base64Encoded: sharedViewModel.profileUser.profileImage!)!)
        }
        sharedViewModel.fullname = sharedViewModel.currentUser.fullname ?? ""
        sharedViewModel.description = sharedViewModel.currentUser.description ?? ""
    }
}
