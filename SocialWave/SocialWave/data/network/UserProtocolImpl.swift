import Foundation
import Alamofire

//class that implements the user protocol functions
class UserProtocolImpl: UserProtocol {
    var customSession: Session
    
    init()  {
        customSession = MakeHttpsConfig.configurations()
    }
    
    //function that retrieves the users when the current user searches
    func retrieveUsers(data: [String: String]) async throws -> Data {
        let url = Constants.BASE_URL + "socialwave/search-users"
        let token: String? = data["token"]
        let headers: HTTPHeaders = [
            "authorization" : "Bearer \(token!)"
        ]
        let parameters: [String: String] = [
            "text": data["text"] ?? ""
        ]
        let response = try await customSession.request(url, method: .get, parameters: parameters, encoding: URLEncoding.queryString, headers: headers).validate().serializingData().value
        return response
    }
    
    //function that edits current user's profile
    func editUserProfile(data: [String: String], profileImage: Data) async throws -> Data {
        let url = Constants.BASE_URL + "socialwave/edit-user-profile"
        let token: String? = data["token"]
        let headers: HTTPHeaders = [
            "authorization" : "Bearer \(token!)"
        ]
        let response = try await customSession.upload(
            multipartFormData: { multipartFormData in multipartFormData.append(profileImage, withName: "profileImage", fileName: "image.jpg", mimeType: "image/jpeg")
                data.forEach { key, value in
                    multipartFormData.append(Data(value.utf8), withName: key)
                }
            }, to: url, method: .post, headers: headers).validate().serializingData().value
        return response
    }
    
    //function that retrieves the friends of the current user
    func fetchFriends(data: [String: String]) async throws -> Data {
        let url = Constants.BASE_URL + "socialwave/find-friends"
        let token: String? = data["token"]
        let headers: HTTPHeaders = [
            "authorization" : "Bearer \(token!)"
        ]
        let parameters: [String: String] = [
            "username": data["username"] ?? ""
        ]
        let response = try await customSession.request(url, method: .get, parameters: parameters, encoding: URLEncoding.queryString,headers: headers).validate().serializingData().value
        return response
    }
    
    //function that retrieves the friend requests of the current user
    func fetchRequests(data: [String: String]) async throws -> Data {
        let url = Constants.BASE_URL + "socialwave/find-requests"
        let token: String? = data["token"]
        let headers: HTTPHeaders = [
            "authorization" : "Bearer \(token!)"
        ]
        let response = try await customSession.request(url, method: .get, parameters: nil, headers: headers).validate().serializingData().value
        return response
    }
    
    //function that accepts a friend request
    func acceptRequest(data: [String: String]) async throws -> Data {
        let url = Constants.BASE_URL + "socialwave/accept-request"
        let token: String? = data["token"]
        let headers: HTTPHeaders = [
            "authorization" : "Bearer \(token!)"
        ]
        let parameters: [String: String] = [
            "userId": data["userId"] ?? "",
            "requesterId": data["requesterId"] ?? ""
        ]
        let response = try await customSession.request(url, method: .patch, parameters: parameters, encoding: URLEncoding.queryString, headers: headers).validate().serializingData().value
        return response
    }
    
    //function that rejects a friend request
    func rejectRequest(data: [String: String]) async throws -> Data {
        let url = Constants.BASE_URL + "socialwave/reject-request"
        let token: String? = data["token"]
        let headers: HTTPHeaders = [
            "authorization" : "Bearer \(token!)"
        ]
        let parameters: [String: String] = [
            "userId": data["userId"] ?? "",
            "requesterId": data["requesterId"] ?? ""
        ]
        let response = try await customSession.request(url, method: .patch, parameters: parameters, encoding: URLEncoding.queryString, headers: headers).validate().serializingData().value
        return response
    }
    
    //function that sends a friend request to other user
    func sendRequest(data: [String: String]) async throws -> Data {
        let url = Constants.BASE_URL + "socialwave/send-request"
        let token: String? = data["token"]
        let headers: HTTPHeaders = [
            "authorization" : "Bearer \(token!)"
        ]
        let parameters: [String: String] = [
            "senderId": data["senderId"] ?? "",
            "receiverId": data["receiverId"] ?? ""
        ]
        let response = try await customSession.request(url, method: .patch, parameters: parameters, encoding: URLEncoding.queryString, headers: headers).validate().serializingData().value
        return response
    }
    
    //function that unsends a friend request
    func unsendRequest(data: [String: String]) async throws -> Data {
        let url = Constants.BASE_URL + "socialwave/unsend-request"
        let token: String? = data["token"]
        let headers: HTTPHeaders = [
            "authorization" : "Bearer \(token!)"
        ]
        let parameters: [String: String] = [
            "senderId": data["senderId"] ?? "",
            "receiverId": data["receiverId"] ?? ""
        ]
        let response = try await customSession.request(url, method: .patch, parameters: parameters, encoding: URLEncoding.queryString, headers: headers).validate().serializingData().value
        return response
    }
    
    //function that deletes a friend for the current user
    func deleteFriend(data: [String: String]) async throws -> Data {
        let url = Constants.BASE_URL + "socialwave/delete-friend"
        let token: String? = data["token"]
        let headers: HTTPHeaders = [
            "authorization" : "Bearer \(token!)"
        ]
        let parameters: [String: String] = [
            "currentUserId": data["currentUserId"] ?? "",
            "friendUserId": data["friendUserId"] ?? ""
        ]
        let response = try await customSession.request(url, method: .patch, parameters: parameters, encoding: URLEncoding.queryString, headers: headers).validate().serializingData().value
        return response
    }
    
    //function that retrieves the sending requests details, the receiving requests details
    //and the friends details for the current user
    func getSRF(data: [String: String]) async throws -> Data {
        let url = Constants.BASE_URL + "socialwave/fetch-current-user-srf-details"
        let token: String? = data["token"]
        let headers: HTTPHeaders = [
            "authorization" : "Bearer \(token!)"
        ]
        let response = try await customSession.request(url, method: .get, parameters: nil, headers: headers).validate().serializingData().value
        return response
    }
    
    //function that inserts a new post in the current user's profile
    func insertPost(data: [String: String], images: [Data]) async throws -> Data {
        let url = Constants.BASE_URL + "socialwave/upload-post"
        let token: String? = data["token"]
        let headers: HTTPHeaders = [
            "authorization" : "Bearer \(token!)"
        ]
        let response = try await customSession.upload(
            multipartFormData: { multipartFormData in 
                images.forEach { imageData in
                    multipartFormData.append(imageData, withName: "postImages", fileName: "image.jpg", mimeType: "image/jpeg")
                }
                data.forEach { key, value in
                    multipartFormData.append(Data(value.utf8), withName: key)
                }
            }, to: url, method: .post, headers: headers).validate().serializingData().value
        return response
    }
    
    //function that retrieves all the details about the profile of the current user
    func getUserAndPosts(data: [String: String]) async throws -> Data {
        let url = Constants.BASE_URL + "socialwave/get-user-posts"
        let token: String? = data["token"]
        let headers: HTTPHeaders = [
            "authorization" : "Bearer \(token!)"
        ]
        let username: [String: String] = [
            "username": data["username"] ?? ""
        ]
        let response = try await customSession.request(url, method: .get, parameters: username, encoding: URLEncoding.queryString, headers: headers).validate().serializingData().value
        return response
    }
    
    //function that retrieves the suggested friends for the current user
    func fetchSuggestedFriends(data: [String: String]) async throws -> Data {
        let url = Constants.BASE_URL + "socialwave/find-suggested-friends"
        let token: String? = data["token"]
        let headers: HTTPHeaders = [
            "authorization" : "Bearer \(token!)"
        ]
        let response = try await customSession.request(url, method: .get, parameters: nil, headers: headers).validate().serializingData().value
        return response
    }
}
