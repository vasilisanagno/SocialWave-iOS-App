import Foundation

//struct model that decodes data to take the number of unseen notifications and chats
struct UnseenNotifOrChatsResponse: Codable {
    let unseenNotifications: Int?
    let numOfUnseenChats: Int?
}
