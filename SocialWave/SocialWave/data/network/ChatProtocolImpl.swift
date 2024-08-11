import Foundation
import Alamofire

//class that implements the chat protocol functions
class ChatProtocolImpl: ChatProtocol {
    var customSession: Session
    
    init()  {
        customSession = MakeHttpsConfig.configurations()
    }
    
    //function that retrieves the chats to show them in the inbox
    func getInbox(data: [String: String]) async throws -> Data {
        let url = Constants.BASE_URL + "socialwave/get-inbox"
        let token: String? = data["token"]
        let headers: HTTPHeaders = [
            "authorization" : "Bearer \(token!)"
        ]
        let response = try await customSession.request(url, method: .get, parameters: nil, headers: headers).validate().serializingData().value
        return response
    }
    
    //function that retieves the friends of the user that don't have yet a chat with the current user
    func getNewChatFriends(data: [String: String]) async throws -> Data {
        let url = Constants.BASE_URL + "socialwave/get-new-chat-friends"
        let token: String? = data["token"]
        let headers: HTTPHeaders = [
            "authorization" : "Bearer \(token!)"
        ]
        let response = try await customSession.request(url, method: .get, parameters: nil, headers: headers).validate().serializingData().value
        return response
    }
    
    //function that creates a new chat in the database
    func createNewChat(data: [String: String]) async throws -> Data {
        let url = Constants.BASE_URL + "socialwave/create-new-chat"
        let token: String? = data["token"]
        let headers: HTTPHeaders = [
            "authorization" : "Bearer \(token!)"
        ]
        let parameters: [String: String] = [
            "chatMember": data["chatMember"] ?? ""
        ]
        let response = try await customSession.request(url, method: .put, parameters: parameters, headers: headers).validate().serializingData().value
        return response
    }
    
    //function that deletes a chat in the database
    func deleteChat(data: [String: String]) async throws -> Data {
        let url = Constants.BASE_URL + "socialwave/delete-chat"
        let token: String? = data["token"]
        let headers: HTTPHeaders = [
            "authorization" : "Bearer \(token!)"
        ]
        let parameters: [String: String] = [
            "chatId": data["chatId"] ?? ""
        ]
        let response = try await customSession.request(url, method: .delete, parameters: parameters, encoding: URLEncoding.queryString, headers: headers).validate().serializingData().value
        return response
    }
    
    //function that retrieves the messages of a specific chat
    func getMessages(data: [String: String]) async throws -> Data {
        let url = Constants.BASE_URL + "socialwave/get-messages"
        let token: String? = data["token"]
        let headers: HTTPHeaders = [
            "authorization" : "Bearer \(token!)"
        ]
        let parameters: [String: String] = [
            "chatId": data["chatId"] ?? ""
        ]
        let response = try await customSession.request(url, method: .get, parameters: parameters, encoding: URLEncoding.queryString, headers: headers).validate().serializingData().value
        return response
    }
    
    //function that creates a new message in a specific chat
    func createAMessage(data: [String: String]) async throws -> Data {
        let url = Constants.BASE_URL + "socialwave/create-message"
        let token: String? = data["token"]
        let headers: HTTPHeaders = [
            "authorization" : "Bearer \(token!)"
        ]
        let parameters: [String: String] = [
            "currentUserId": data["currentUserId"] ?? "",
            "chatMemberId": data["chatMemberId"] ?? "",
            "chatMemberUsername": data["chatMemberUsername"] ?? "",
            "text": data["text"] ?? "",
        ]
        let response = try await customSession.request(url, method: .put, parameters: parameters, headers: headers).validate().serializingData().value
        return response
    }
    
    //function that updates the last message seen to true when the user sees the chat and the messages
    func makeLastMessageSeen(data: [String: String]) async throws -> Data {
        let url = Constants.BASE_URL + "socialwave/update-last-message-seen"
        let token: String? = data["token"]
        let headers: HTTPHeaders = [
            "authorization" : "Bearer \(token!)"
        ]
        let parameters: [String: String] = [
            "chatId": data["chatId"] ?? ""
        ]
        let response = try await customSession.request(url, method: .patch, parameters: parameters, encoding: URLEncoding.queryString, headers: headers).validate().serializingData().value
        return response
    }
    
    //function that retrieves the number of unseen chats
    func fetchNumOfUnseenChats(data: [String: String]) async throws -> Data {
        let url = Constants.BASE_URL + "socialwave/get-of-unseen-chats"
        let token: String? = data["token"]
        let headers: HTTPHeaders = [
            "authorization" : "Bearer \(token!)"
        ]
        let response = try await customSession.request(url, method: .get, parameters: nil, headers: headers).validate().serializingData().value
        return response
    }
}
