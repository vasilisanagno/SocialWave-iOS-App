import Foundation

//repository class for the functionalities that has connection with the comments and comment details
//and takes the data from the comment protocol and decode them
class CommentRepository {
    private let service: CommentProtocol
    
    init(service: CommentProtocol) {
        self.service = service
    }
    
    func getPostComments(token: String, postId: String) async throws -> [CommentDetails] {
        let data = try await service.getPostComments(data: [
            "token": token,
            "postId": postId
        ])
        let response = try JSONDecoder().decode([CommentDetails].self, from: data)
        return response
    }
    
    func addCommentToPost(token: String, postId: String, userId: String, content: String) async throws -> [CommentDetails] {
        let data = try await service.addComment(data: [
            "token": token,
            "postId": postId,
            "userId": userId,
            "content": content
        ])
        let response = try JSONDecoder().decode([CommentDetails].self, from: data)
        return response
    }
    
    func deleteCommentFromPost(token: String, postId: String, userId: String, content: String) async throws -> [CommentDetails] {
        let data = try await service.deleteComment(data: [
            "token": token,
            "postId": postId,
            "userId": userId,
            "content": content
        ])
        let response = try JSONDecoder().decode([CommentDetails].self, from: data)
        return response
    }
    
    func addLikeToCommentForPost(token: String, postId: String, userId: String, content: String, currentUser: String) async throws -> [String] {
        let data = try await service.addLikeToComment(data: [
            "token": token,
            "postId": postId,
            "userId": userId,
            "content": content,
            "currentUser": currentUser
        ])
        let response = try JSONDecoder().decode([String].self, from: data)
        return response
    }
    
    func deleteLikeFromCommentForPost(token: String, postId: String, userId: String, content: String, currentUser: String) async throws -> [String] {
        let data = try await service.deleteLikeFromComment(data: [
            "token": token,
            "postId": postId,
            "userId": userId,
            "content": content,
            "currentUser": currentUser
        ])
        let response = try JSONDecoder().decode([String].self, from: data)
        return response
    }
}
