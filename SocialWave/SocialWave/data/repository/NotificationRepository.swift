import Foundation

//repository class for the functionalities that has connection with the notifications and notification details
//and takes the data from the notification protocol and decode them
class NotificationRepository {
    private let service: NotificationProtocol
    
    init(service: NotificationProtocol) {
        self.service = service
    }
    
    func getNotifForTheCurrentUser(token: String) async throws -> [NotificationDetails] {
        let data = try await service.getNotifications(data: [
            "token": token
        ])
        let response = try JSONDecoder().decode([NotificationDetails].self, from: data)
        return response
    }
    
    func getUnseenNotifForTheCurrentUser(token: String) async throws -> Int {
        let data = try await service.getNumOfUnseenNotifications(data: [
            "token": token
        ])
        let response = try JSONDecoder().decode(UnseenNotifOrChatsResponse.self, from: data)
        return response.unseenNotifications!
    }
    
    func deleteNotifOfTheCurrentUser(token: String) async throws {
        _ = try await service.deleteNotifications(data: [
            "token": token
        ])
    }
}
