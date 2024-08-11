import Foundation

//protocol that contains functions that communicates with server with requests for chat
protocol ChatProtocol {
    func getInbox(data: [String: String]) async throws -> Data
    func getNewChatFriends(data: [String: String]) async throws -> Data
    func createNewChat(data: [String: String]) async throws -> Data
    func deleteChat(data: [String: String]) async throws -> Data
    func getMessages(data: [String: String]) async throws -> Data
    func createAMessage(data: [String: String]) async throws -> Data
    func makeLastMessageSeen(data: [String: String]) async throws -> Data
    func fetchNumOfUnseenChats(data: [String: String]) async throws -> Data
}
