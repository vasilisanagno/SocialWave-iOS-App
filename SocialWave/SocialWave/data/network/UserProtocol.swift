import Foundation

//protocol that contains functions that communicates with server with requests for different functionalities
//that have connection with the user and the current user
protocol UserProtocol {
    func retrieveUsers(data: [String: String]) async throws -> Data
    func editUserProfile(data: [String: String], profileImage: Data) async throws -> Data
    func fetchFriends(data: [String: String]) async throws -> Data
    func fetchRequests(data: [String: String]) async throws -> Data
    func acceptRequest(data: [String: String]) async throws -> Data
    func rejectRequest(data: [String: String]) async throws -> Data
    func sendRequest(data: [String: String]) async throws -> Data
    func unsendRequest(data: [String: String]) async throws -> Data
    func deleteFriend(data: [String: String]) async throws -> Data
    func getSRF(data: [String: String]) async throws -> Data
    func insertPost(data: [String: String], images: [Data]) async throws -> Data
    func getUserAndPosts(data: [String: String]) async throws -> Data
    func fetchSuggestedFriends(data: [String: String]) async throws -> Data
}
