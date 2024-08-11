import Foundation

//protocol that contains functions that communicates with server with requests for comment
protocol CommentProtocol {
    func getPostComments(data: [String: String]) async throws -> Data
    func addComment(data: [String: String]) async throws -> Data
    func deleteComment(data: [String: String]) async throws -> Data
    func addLikeToComment(data: [String: String]) async throws -> Data
    func deleteLikeFromComment(data: [String: String]) async throws -> Data
}
