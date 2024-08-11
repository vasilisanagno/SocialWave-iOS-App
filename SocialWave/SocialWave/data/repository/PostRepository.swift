import Foundation

//repository class for the functionalities that has connection with the post and post details
//and takes the data from the post protocol and decode them
class PostRepository {
    private let service: PostProtocol
    
    init(service: PostProtocol) {
        self.service = service
    }
    
    func getPostLikes(token: String, post: String) async throws -> [UserDetails] {
        let data = try await service.getPostLikes(data: [
            "token": token,
            "post": post
        ])
        let response = try JSONDecoder().decode([UserDetails].self, from: data)
        return response
    }
    
    func editPostCaption(token: String, postId: String, newCaption: String) async throws -> PostDetails {
        let data = try await service.editPostCaption(data: [
            "token": token,
            "postId": postId,
            "newCaption": newCaption
        ])
        let response = try JSONDecoder().decode(PostDetails.self, from: data)
        return response
    }
    
    func deletePost(token: String, postId: String) async throws -> ApiResponse {
        let data = try await service.deletePost(data: [
            "token": token,
            "postId": postId
        ])
        let response = try JSONDecoder().decode(ApiResponse.self, from: data)
        return response
    }
    
    func getFriendsPost(token: String) async throws -> [PostDetails] {
        let data = try await service.fetchFriendsPosts(data: [
            "token": token
        ])
        let response = try JSONDecoder().decode([PostDetails].self, from: data)
        return response
    }
    
    func addLike(token: String, userId: String, postId: String) async throws -> [String] {
        let data = try await service.addLike(data: [
            "token": token,
            "userId": userId,
            "postId": postId
        ])
        let response = try JSONDecoder().decode(NewLikesResponse.self, from: data)
        return response.likes
    }
    
    func deleteLike(token: String, userId: String, postId: String) async throws -> [String] {
        let data = try await service.deleteLike(data: [
            "token": token,
            "userId": userId,
            "postId": postId
        ])
        let response = try JSONDecoder().decode(NewLikesResponse.self, from: data)
        return response.likes
    }
}
