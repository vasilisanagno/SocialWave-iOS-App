import Foundation
import SwiftUI

//repository class for the functionalities that have connection with the user and user details
//and takes the data from the user protocol and decode them 
class UserRepository {
    private let service: UserProtocol
    
    init(service: UserProtocol) {
        self.service = service
    }
    
    func searchUsers(text: String, token: String) async throws -> [UserDetails] {
        let data = try await service.retrieveUsers(data: [
            "token": token,
            "text": text
        ])
        let response = try JSONDecoder().decode([UserDetails].self, from: data)
        return response
    }
    
    func editUser(username: String, fullname: String, description: String, token: String, profileImage: UIImage)
    async throws -> UserDetails {
        let data = try await service.editUserProfile(data: [
            "token": token,
            "username": username,
            "fullname": fullname,
            "description": description
        ], profileImage: profileImage.jpegData(compressionQuality: 0.5) ?? Data())
        let response = try JSONDecoder().decode(UserDetails.self, from: data)
        return response
    }
    
    func getFriendsData(token: String, username: String) async throws -> [UserDetails] {
        let data = try await service.fetchFriends(data: [
            "token": token,
            "username": username
        ])
        let response = try JSONDecoder().decode([UserDetails].self, from: data)
        return response
    }
    
    func getFriendRequests(token: String) async throws -> [UserDetails] {
        let data = try await service.fetchRequests(data: [
            "token": token
        ])
        let response = try JSONDecoder().decode([UserDetails].self, from: data)
        return response
    }
    
    func makeNewFriend(token: String, userId: String, requesterId: String) async throws -> ([String], [String]) {
        let data = try await service.acceptRequest(data: [
            "token": token,
            "userId": userId,
            "requesterId": requesterId
        ])
        let response = try JSONDecoder().decode(RequestDataResponse.self, from: data)
        return (response.receiving, response.friends)
    }
    
    func deletePossibleFriend(token: String, userId: String, requesterId: String) async throws -> ([String], [String]) {
        let data = try await service.rejectRequest(data: [
            "token": token,
            "userId": userId,
            "requesterId": requesterId
        ])
        let response = try JSONDecoder().decode(RequestDataResponse.self, from: data)
        return (response.receiving, response.friends)
    }
    
    func willingToMakeNewFriend(token: String, senderId: String, receiverId: String) async throws -> [String] {
        let data = try await service.sendRequest(data: [
            "token": token,
            "senderId": senderId,
            "receiverId": receiverId
        ])
        let response = try JSONDecoder().decode([String].self, from: data)
        return response
    }
    
    func notWillingToMakeNewFriend(token: String, senderId: String, receiverId: String) async throws -> [String] {
        let data = try await service.unsendRequest(data: [
            "token": token,
            "senderId": senderId,
            "receiverId": receiverId
        ])
        let response = try JSONDecoder().decode([String].self, from: data)
        return response
    }
    
    func deleteFriendship(token: String, currentUserId: String, friendUserId: String) async throws -> [String] {
        let data = try await service.deleteFriend(data: [
            "token": token,
            "currentUserId": currentUserId,
            "friendUserId": friendUserId
        ])
        let response = try JSONDecoder().decode([String].self, from: data)
        return response
    }
    
    func renewSRFDetails(token: String) async throws -> ([String], [String], [String]) {
        let data = try await service.getSRF(data: [
            "token": token
        ])
        let response = try JSONDecoder().decode(RequestDataResponse.self, from: data)
        return (response.sending!, response.receiving, response.friends)
    }
    
    func uploadPostData(token: String, images: [UIImage], caption: String, userId: String) async throws -> (UserDetails,[PostDetails]) {
        var imagesData: [Data] = []
        images.forEach { image in
            imagesData.append(image.jpegData(compressionQuality: 0.5) ?? Data())
            
        }
        let data = try await service.insertPost(data: [
            "token": token,
            "caption": caption,
            "userId": userId
        ], images: imagesData)
        let response = try JSONDecoder().decode(UserDataResponse.self, from: data)
        return (response.user, response.posts)
    }
    
    func getUserAndPostsDetails(token: String, username: String) async throws -> (UserDetails, [PostDetails]) {
        let data = try await service.getUserAndPosts(data: [
            "token": token,
            "username": username
        ])
        let response = try JSONDecoder().decode(UserDataResponse.self, from: data)
        return (response.user, response.posts)
    }
    
    func getSuggestedFriends(token: String) async throws -> [SuggestedFriendDetails] {
        let data = try await service.fetchSuggestedFriends(data: [
            "token": token
        ])
        let response = try JSONDecoder().decode([SuggestedFriendDetails].self, from: data)
        return response
    }
}
