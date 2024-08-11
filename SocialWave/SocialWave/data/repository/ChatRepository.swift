import Foundation

//repository class for the functionalities that has connection with the chats and chat details
//and takes the data from the chat protocol and decode them
class ChatRepository {
    private let service: ChatProtocol
    
    init(service: ChatProtocol) {
        self.service = service
    }
    
    func getInboxChats(token: String) async throws -> [ChatDetails] {
        let data = try await service.getInbox(data: [
            "token": token
        ])
        let response = try JSONDecoder().decode([ChatDetails].self, from: data)
        return response
    }
    
    func getPossibleNewChatFriends(token: String) async throws -> [UserDetails] {
        let data = try await service.getNewChatFriends(data: [
            "token": token
        ])
        let response = try JSONDecoder().decode([UserDetails].self, from: data)
        return response
    }
    
    func createANewChat(token: String, chatMember: String) async throws -> [ChatDetails] {
        let data = try await service.createNewChat(data: [
            "token": token,
            "chatMember": chatMember
        ])
        let response = try JSONDecoder().decode([ChatDetails].self, from: data)
        return response
    }
    
    func deleteAChat(token: String, chatId: String) async throws -> [ChatDetails] {
        let data = try await service.deleteChat(data: [
            "token": token,
            "chatId": chatId
        ])
        let response = try JSONDecoder().decode([ChatDetails].self, from: data)
        return response
    }
    
    func retrieveMessagesForAChat(token: String, chatId: String) async throws -> [MessageDetails] {
        let data = try await service.getMessages(data: [
            "token": token,
            "chatId": chatId
        ])
        let response = try JSONDecoder().decode([MessageDetails].self, from: data)
        return response
    }
    
    func createMessageInAChat(token: String, currentUserId: String, chatMemberId: String, chatMemberUsername: String, text: String) async throws -> MessageDetails {
        let data = try await service.createAMessage(data: [
            "token": token,
            "currentUserId": currentUserId,
            "chatMemberId": chatMemberId,
            "chatMemberUsername": chatMemberUsername,
            "text": text
        ])
        let response = try JSONDecoder().decode(MessageDetails.self, from: data)
        return response
    }
    
    func updateLastMessageSeen(token: String, chatId: String) async throws {
        _ = try await service.makeLastMessageSeen(data: [
            "token": token,
            "chatId": chatId
        ])
    }
    
    func getNumOfUnseenChats(token: String) async throws -> Int {
        let data = try await service.fetchNumOfUnseenChats(data: [
            "token": token
        ])
        let response = try JSONDecoder().decode(UnseenNotifOrChatsResponse.self, from: data)
        return response.numOfUnseenChats!
    }
}
