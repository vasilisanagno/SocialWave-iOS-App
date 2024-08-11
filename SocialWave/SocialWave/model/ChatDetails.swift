import Foundation

//struct model that keeps details about the chat
struct ChatDetails: Identifiable, Codable {
    let id: String
    let username: String
    let chatMemberId: String
    let chatMemberUsername: String
    let chatMemberFullname: String?
    let chatMemberProfileImage: String?
    let lastMessageSeen: Bool
    var lastMessage: String?
    let lastMessageCreatedAt: String?
    
    init() {
        self.id = ""
        self.username = ""
        self.chatMemberId = ""
        self.chatMemberUsername = ""
        self.chatMemberFullname = ""
        self.chatMemberProfileImage = nil
        self.lastMessageSeen = true
        self.lastMessage = nil
        self.lastMessageCreatedAt = nil
    }
}
