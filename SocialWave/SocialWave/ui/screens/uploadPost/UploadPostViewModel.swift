import SwiftUI
import PhotosUI
import KeychainSwift

//view model that keeps the variable state across multiple views and communicates with the server
//to upload a new post for the current user
@MainActor
class UploadPostViewModel: ObservableObject {
    private let repository: UserRepository
    private let sharedViewModel: SharedViewModel
    @Published var selectedItems: [PhotosPickerItem] = [] {
        didSet {
            Task { await loadImages(fromItems: selectedItems) }
        }
    }
    @Published var postUIImages: [IdentifiableUIImage] = []
    @Published var uiImages: [UIImage] = []
    
    init(repository: UserRepository = DIContainer.shared.container.resolve(UserRepository.self)!,
         sharedViewModel: SharedViewModel = DIContainer.shared.container.resolve(SharedViewModel.self)!) {
        self.repository = repository
        self.sharedViewModel = sharedViewModel
    }
    func loadImages(fromItems items: [PhotosPickerItem]) async {
        var newImages: [IdentifiableUIImage] = []
        uiImages = []
        for item in items {
            guard let data = try? await item.loadTransferable(type: Data.self) else { continue }
            if let uiImage = UIImage(data: data) {
                let identifiableImage = IdentifiableUIImage(image: uiImage)
                newImages.append(identifiableImage)
                uiImages.append(uiImage)
            }
        }
        DispatchQueue.main.async {
            self.postUIImages = newImages
        }
    }
    
    func uploadPost() async throws {
        do {
            (sharedViewModel.currentUser, sharedViewModel.currentUserPosts) = try await repository.uploadPostData(
                token: KeychainSwift().get("jwt") ?? "",
                images: uiImages,
                caption: sharedViewModel.caption,
                userId: sharedViewModel.currentUser.id
            )
        } catch {
            print(error)
            if error.asAFError?.responseCode == 401 {
                sharedViewModel.unauthorizedAccess()
            }
        }
    }
}
