import Foundation
import Alamofire

//class that implements the post protocol functions
class PostProtocolImpl: PostProtocol {
    var customSession: Session
    
    init()  {
        customSession = MakeHttpsConfig.configurations()
    }
    
    //function that retrieves the users that made a like in a specific post
    func getPostLikes(data: [String: String]) async throws -> Data {
        let url = Constants.BASE_URL + "socialwave/get-post-likes"
        let token: String? = data["token"]
        let headers: HTTPHeaders = [
            "authorization" : "Bearer \(token!)"
        ]
        let post: [String: String] = [
            "post": data["post"] ?? ""
        ]
        let response = try await customSession.request(url, method: .get, parameters: post, encoding: URLEncoding.queryString, headers: headers).validate().serializingData().value
        return response
    }
    
    //function that makes edit post updating the post's caption
    func editPostCaption(data: [String: String]) async throws -> Data {
        let url = Constants.BASE_URL + "socialwave/update-post-caption"
        let token: String? = data["token"]
        let headers: HTTPHeaders = [
            "authorization" : "Bearer \(token!)"
        ]
        let parameters: [String: String] = [
            "postId": data["postId"] ?? "",
            "newCaption": data["newCaption"] ?? ""
        ]
        let response = try await customSession.request(url, method: .patch, parameters: parameters, encoding: URLEncoding.queryString, headers: headers).validate().serializingData().value
        return response
    }
    
    //function that makes edit post deleting the post
    func deletePost(data: [String: String]) async throws -> Data {
        let url = Constants.BASE_URL + "socialwave/delete-post"
        let token: String? = data["token"]
        let headers: HTTPHeaders = [
            "authorization" : "Bearer \(token!)"
        ]
        let parameters: [String: String] = [
            "postId": data["postId"] ?? ""
        ]
        let response = try await customSession.request(url, method: .delete, parameters: parameters, encoding: URLEncoding.queryString, headers: headers).validate().serializingData().value
        return response
    }
    
    //function that retrieves all the posts of the friends of the current user
    func fetchFriendsPosts(data: [String: String]) async throws -> Data {
        let url = Constants.BASE_URL + "socialwave/fetch-friends-posts"
        let token: String? = data["token"]
        let headers: HTTPHeaders = [
            "authorization" : "Bearer \(token!)"
        ]
        let response = try await customSession.request(url, method: .get, parameters: nil, headers: headers).validate().serializingData().value
        return response
    }
    
    //function that adds a like in a post
    func addLike(data: [String: String]) async throws -> Data {
        let url = Constants.BASE_URL + "socialwave/add-like"
        let token: String? = data["token"]
        let headers: HTTPHeaders = [
            "authorization" : "Bearer \(token!)"
        ]
        let parameters: [String: String] = [
            "userId": data["userId"] ?? "",
            "postId": data["postId"] ?? ""
        ]
        let response = try await customSession.request(url, method: .patch, parameters: parameters, encoding: URLEncoding.queryString, headers: headers).validate().serializingData().value
        return response
    }
    
    //function that deletes a like from a post
    func deleteLike(data: [String: String]) async throws -> Data {
        let url = Constants.BASE_URL + "socialwave/delete-like"
        let token: String? = data["token"]
        let headers: HTTPHeaders = [
            "authorization" : "Bearer \(token!)"
        ]
        let parameters: [String: String] = [
            "userId": data["userId"] ?? "",
            "postId": data["postId"] ?? ""
        ]
        let response = try await customSession.request(url, method: .patch, parameters: parameters, encoding: URLEncoding.queryString, headers: headers).validate().serializingData().value
        return response
    }
}
