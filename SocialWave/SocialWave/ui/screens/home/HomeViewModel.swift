import Foundation
import PhotosUI
import SwiftUI
import KeychainSwift

//view model that keeps the variable state across multiple views
//and communicates with the server to retrieve posts, friends that made like in posts, comments and suggested friends
//and add/delete a like, a comment and a like to a comment
@MainActor
class HomeViewModel: ObservableObject {
    private let userRepository: UserRepository
    private let postRepository: PostRepository
    private let commentRepository: CommentRepository
    private let sharedViewModel: SharedViewModel
    private let socketViewModel: SocketViewModel
    @Published var likeClicked: [Bool] = []
    @Published var commentText: String = ""
    @Published var commentProgressBar = false
    @Published var likeProgressBar = false
    
    init(postRepository: PostRepository = DIContainer.shared.container.resolve(PostRepository.self)!,
         commentRepository: CommentRepository = DIContainer.shared.container.resolve(CommentRepository.self)!,
         userRepository: UserRepository = DIContainer.shared.container.resolve(UserRepository.self)!,
         sharedViewModel: SharedViewModel = DIContainer.shared.container.resolve(SharedViewModel.self)!,
         socketViewModel: SocketViewModel = DIContainer.shared.container.resolve(SocketViewModel.self)!) {
        self.postRepository = postRepository
        self.commentRepository = commentRepository
        self.userRepository = userRepository
        self.sharedViewModel = sharedViewModel
        self.socketViewModel = socketViewModel
    }
    
    private func updateTheHeartOfLikesInComments() {
        likeClicked = Array(repeating: false, count: sharedViewModel.postComments.count)
        for i in 0..<sharedViewModel.postComments.count {
            for j in 0..<sharedViewModel.postComments[i].likes.count {
                if sharedViewModel.postComments[i].likes[j] == sharedViewModel.currentUser.id {
                    likeClicked[i] = true
                }
            }
        }
    }
    
    func fetchPosts() async throws {
        do {
            sharedViewModel.showProgress = true
            sharedViewModel.friendsPosts = try await postRepository.getFriendsPost(
                token: KeychainSwift().get("jwt") ?? ""
            )
            try await getSuggestedFriends()
            sharedViewModel.showProgress = false
        } catch {
            print(error)
            if error.asAFError?.responseCode == 401 {
                sharedViewModel.unauthorizedAccess()
            }
        }
    }
    
    //likes
    func retrievePostLikesTask(index: Int) {
        Task {
            try await retrievePostLikes(index: index)
        }
    }
    
    private func retrievePostLikes(index: Int) async throws {
        do {
            likeProgressBar = true
            sharedViewModel.friendsLikedPost = try await postRepository.getPostLikes(token: KeychainSwift().get("jwt") ?? "", post: sharedViewModel.selectedTab == 5 || sharedViewModel.selectedTab == 2 ? sharedViewModel.profileUserPosts[index].id : sharedViewModel.friendsPosts[index].id)
            likeProgressBar = false
        } catch {
            print(error)
            if error.asAFError?.responseCode == 401 {
                sharedViewModel.unauthorizedAccess()
            }
        }
    }
    
    //likes
    func addLike(userId: String, postId: String, index: Int) async throws {
        do {
            let likes = try await postRepository.addLike(
                token: KeychainSwift().get("jwt") ?? "",
                userId: userId,
                postId: postId
            )
            if sharedViewModel.selectedTab == 2 || sharedViewModel.selectedTab == 5 {
                sharedViewModel.profileUserPosts[index].likes = likes
            }
            else {
                sharedViewModel.friendsPosts[index].likes = likes
            }
        } catch {
            print(error)
            if error.asAFError?.responseCode == 401 {
                sharedViewModel.unauthorizedAccess()
            }
        }
    }
    
    func deleteLike(userId: String, postId: String, index: Int) async throws {
        do {
            let likes = try await postRepository.deleteLike(
                token: KeychainSwift().get("jwt") ?? "",
                userId: userId,
                postId: postId
            )
            if sharedViewModel.selectedTab == 2 || sharedViewModel.selectedTab == 5 {
                sharedViewModel.profileUserPosts[index].likes = likes
            }
            else {
                sharedViewModel.friendsPosts[index].likes = likes
            }
        } catch {
            print(error)
            if error.asAFError?.responseCode == 401 {
                sharedViewModel.unauthorizedAccess()
            }
        }
    }
    
    //comments
    func retrievePostCommentsTask(index: Int) {
        Task {
            try await retrievePostComments(index: index)
        }
    }
    
    private func retrievePostComments(index: Int) async throws {
        do {
            commentProgressBar = true
            sharedViewModel.postComments = try await commentRepository.getPostComments(token: KeychainSwift().get("jwt") ?? "", postId: sharedViewModel.selectedTab == 5 || sharedViewModel.selectedTab == 2 ? sharedViewModel.profileUserPosts[index].id : sharedViewModel.friendsPosts[index].id)
            updateTheHeartOfLikesInComments()
            commentProgressBar = false
        } catch {
            print(error)
            if error.asAFError?.responseCode == 401 {
                sharedViewModel.unauthorizedAccess()
            }
        }
    }
    
    func addCommentTask(index: Int) {
        Task {
            try await addComment(index: index)
        }
    }
    
    private func addComment(index: Int) async throws {
        do {
            commentProgressBar = true
            sharedViewModel.postComments = try await commentRepository.addCommentToPost(token: KeychainSwift().get("jwt") ?? "", postId: sharedViewModel.postComments.count != 0 ?  sharedViewModel.postComments[0].post : (sharedViewModel.selectedTab == 5 || sharedViewModel.selectedTab == 2) ? sharedViewModel.profileUserPosts[index].id : sharedViewModel.friendsPosts[index].id , userId: sharedViewModel.currentUser.id, content: commentText)
            commentText = ""
            updateTheHeartOfLikesInComments()
            socketViewModel.sendNotification(sender: sharedViewModel.currentUser.username, receiver: (sharedViewModel.selectedTab == 5 || sharedViewModel.selectedTab == 2) ? sharedViewModel.profileUserPosts[index].username : sharedViewModel.friendsPosts[index].username)
            commentProgressBar = false
        } catch {
            print(error)
            if error.asAFError?.responseCode == 401 {
                sharedViewModel.unauthorizedAccess()
            }
        }
    }
    
    func deleteCommentTask(index: Int, commentIndex: Int) {
        Task {
            try await deleteComment(index: index, commentIndex: commentIndex)
        }
    }
    
    private func deleteComment(index: Int, commentIndex: Int) async throws {
        do {
            commentProgressBar = true
            sharedViewModel.postComments = try await commentRepository.deleteCommentFromPost(token: KeychainSwift().get("jwt") ?? "", postId: sharedViewModel.postComments.count != 0 ?  sharedViewModel.postComments[0].post : (sharedViewModel.selectedTab == 5 || sharedViewModel.selectedTab == 2) ? sharedViewModel.profileUserPosts[index].id : sharedViewModel.friendsPosts[index].id , userId: sharedViewModel.currentUser.id, content: sharedViewModel.postComments[commentIndex].content)
            updateTheHeartOfLikesInComments()
            commentProgressBar = false
        } catch {
            print(error)
            if error.asAFError?.responseCode == 401 {
                sharedViewModel.unauthorizedAccess()
            }
        }
    }
    
    func addCommentLikeTask(index: Int, commentIndex: Int) {
        Task {
            try await addCommentLike(index: index, commentIndex: commentIndex)
        }
    }
    
    private func addCommentLike(index: Int, commentIndex: Int) async throws {
        do {
            sharedViewModel.postComments[commentIndex].likes = try await commentRepository.addLikeToCommentForPost(token: KeychainSwift().get("jwt") ?? "", postId: sharedViewModel.postComments.count != 0 ?  sharedViewModel.postComments[0].post : (sharedViewModel.selectedTab == 5 || sharedViewModel.selectedTab == 2) ? sharedViewModel.profileUserPosts[index].id : sharedViewModel.friendsPosts[index].id , userId: sharedViewModel.postComments[commentIndex].user, content: sharedViewModel.postComments[commentIndex].content,
                                                                                                                   currentUser: sharedViewModel.currentUser.id)
        } catch {
            print(error)
            if error.asAFError?.responseCode == 401 {
                sharedViewModel.unauthorizedAccess()
            }
        }
    }
    
    func deleteCommentLikeTask(index: Int, commentIndex: Int) {
        Task {
            try await deleteCommentLike(index: index, commentIndex: commentIndex)
        }
    }
    
    private func deleteCommentLike(index: Int, commentIndex: Int) async throws {
        do {
            sharedViewModel.postComments[commentIndex].likes = try await commentRepository.deleteLikeFromCommentForPost(token: KeychainSwift().get("jwt") ?? "", postId: sharedViewModel.postComments.count != 0 ?  sharedViewModel.postComments[0].post : (sharedViewModel.selectedTab == 5 || sharedViewModel.selectedTab == 2) ? sharedViewModel.profileUserPosts[index].id : sharedViewModel.friendsPosts[index].id , userId: sharedViewModel.postComments[commentIndex].user, content: sharedViewModel.postComments[commentIndex].content,
                                                                                                                        currentUser: sharedViewModel.currentUser.id)
        } catch {
            print(error)
            if error.asAFError?.responseCode == 401 {
                sharedViewModel.unauthorizedAccess()
            }
        }
    }
    
    private func getSuggestedFriends() async throws {
        do {
            sharedViewModel.suggestedFriends = try await userRepository.getSuggestedFriends(token: KeychainSwift().get("jwt") ?? "")
            for i in 0..<sharedViewModel.suggestedFriends.count {
                for j in 0..<sharedViewModel.currentUser.sending.count {
                    if sharedViewModel.currentUser.sending[j] == sharedViewModel.suggestedFriends[i].id {
                        sharedViewModel.suggestedFriends[i].pendingOrNot = true
                        break
                    }
                    else if j == sharedViewModel.currentUser.sending.count-1 {
                        sharedViewModel.suggestedFriends[i].pendingOrNot = false
                        break
                    }
                }
                if sharedViewModel.currentUser.sending.count == 0 {
                    sharedViewModel.suggestedFriends[i].pendingOrNot = false
                }
            }
        } catch {
            print(error)
            if error.asAFError?.responseCode == 401 {
                sharedViewModel.unauthorizedAccess()
            }
        }
    }
}
