import Foundation
import KeychainSwift

//view model that communicates with the server to update caption of a post
@MainActor
class EditPostViewModel: ObservableObject {
    private let repository: PostRepository
    private let sharedViewModel: SharedViewModel
    
    init(repository: PostRepository = DIContainer.shared.container.resolve(PostRepository.self)!,
         sharedViewModel: SharedViewModel = DIContainer.shared.container.resolve(SharedViewModel.self)!) {
        self.repository = repository
        self.sharedViewModel = sharedViewModel
    }
    
    func editPostCaption(index: Int, newCaption: String) async throws {
        do {
            sharedViewModel.profileUserPosts[index] = try await repository.editPostCaption(
                token: KeychainSwift().get("jwt") ?? "",
                postId: sharedViewModel.profileUserPosts[index].id,
                newCaption: newCaption
            )
        } catch {
            print(error)
            if error.asAFError?.responseCode == 401 {
                sharedViewModel.unauthorizedAccess()
            }
        }
    }
}
