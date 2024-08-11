import Foundation

//protocol that contains functions that communicates with server with requests for post
protocol PostProtocol {
    func getPostLikes(data: [String: String]) async throws -> Data
    func editPostCaption(data: [String: String]) async throws -> Data
    func deletePost(data: [String: String]) async throws -> Data
    func fetchFriendsPosts(data: [String: String]) async throws -> Data
    func addLike(data: [String: String]) async throws -> Data
    func deleteLike(data: [String: String]) async throws -> Data
}
