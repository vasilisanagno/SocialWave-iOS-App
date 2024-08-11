import Foundation

//protocol that contains functions that communicates with server with requests for notification
protocol NotificationProtocol {
    func getNotifications(data: [String: String]) async throws -> Data
    func getNumOfUnseenNotifications(data: [String: String]) async throws -> Data
    func deleteNotifications(data: [String: String]) async throws -> Data
}
