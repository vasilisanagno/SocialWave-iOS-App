import Foundation
import Alamofire

//class that implements the comment protocol functions
class CommentProtocolImpl: CommentProtocol {
    var customSession: Session
    
    init()  {
        customSession = MakeHttpsConfig.configurations()
    }
    
    //function that retrieves the comments of a specific post
    func getPostComments(data: [String: String]) async throws -> Data {
        let url = Constants.BASE_URL + "socialwave/get-post-comments"
        let token: String? = data["token"]
        let headers: HTTPHeaders = [
            "authorization" : "Bearer \(token!)"
        ]
        let parameters: [String: String] = ["postId": data["postId"] ?? ""]
        let response = try await customSession.request(url, method: .get, parameters: parameters, encoding: URLEncoding.queryString, headers: headers).validate().serializingData().value
        return response
    }
    
    //function that adds a new comment in a specific post
    func addComment(data: [String: String]) async throws -> Data {
        let url = Constants.BASE_URL + "socialwave/add-comment"
        let token: String? = data["token"]
        let headers: HTTPHeaders = [
            "authorization" : "Bearer \(token!)"
        ]
        let parameters = [
            "postId": data["postId"],
            "userId": data["userId"],
            "content": data["content"]
        ]
        let response = try await customSession.request(url, method: .put, parameters: parameters, headers: headers).validate().serializingData().value
        return response
    }
    
    //function that deletes a current user's comment from a post
    func deleteComment(data: [String: String]) async throws -> Data {
        let url = Constants.BASE_URL + "socialwave/delete-comment"
        let token: String? = data["token"]
        let headers: HTTPHeaders = [
            "authorization" : "Bearer \(token!)"
        ]
        let parameters: [String: String] = [
            "postId": data["postId"] ?? "",
            "userId": data["userId"] ?? "",
            "content": data["content"] ?? ""
        ]
        let response = try await customSession.request(url, method: .delete, parameters: parameters, encoding: URLEncoding.queryString, headers: headers).validate().serializingData().value
        return response
    }
    
    //function that adds a like to a comment in a post
    func addLikeToComment(data: [String: String]) async throws -> Data {
        let url = Constants.BASE_URL + "socialwave/add-like-to-comment"
        let token: String? = data["token"]
        let headers: HTTPHeaders = [
            "authorization" : "Bearer \(token!)"
        ]
        let parameters: [String: String] = [
            "postId": data["postId"] ?? "",
            "userId": data["userId"] ?? "",
            "content": data["content"] ?? "",
            "currentUser": data["currentUser"] ?? ""
        ]
        let response = try await customSession.request(url, method: .patch, parameters: parameters, encoding: URLEncoding.queryString, headers: headers).validate().serializingData().value
        return response
    }
    
    //function that removes a like from a comment in a post
    func deleteLikeFromComment(data: [String: String]) async throws -> Data {
        let url = Constants.BASE_URL + "socialwave/delete-like-from-comment"
        let token: String? = data["token"]
        let headers: HTTPHeaders = [
            "authorization" : "Bearer \(token!)"
        ]
        let parameters: [String: String] = [
            "postId": data["postId"] ?? "",
            "userId": data["userId"] ?? "",
            "content": data["content"] ?? "",
            "currentUser": data["currentUser"] ?? ""
        ]
        let response = try await customSession.request(url, method: .patch, parameters: parameters, encoding: URLEncoding.queryString, headers: headers).validate().serializingData().value
        return response
    }
}
