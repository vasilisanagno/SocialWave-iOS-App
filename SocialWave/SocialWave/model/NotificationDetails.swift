import Foundation

//struct model that keeps details about the notification
struct NotificationDetails: Identifiable, Codable {
    let id: String
    let notificationType: String
    let notificationSeen: Bool
    let senderUsername: String
    let senderProfile: String?
    var postImage: String?
    let createdAt: String
    
    init() {
        self.id = ""
        self.notificationType = ""
        self.notificationSeen = false
        self.senderUsername = ""
        self.senderProfile = nil
        self.postImage = nil
        self.createdAt = ""
    }
}
