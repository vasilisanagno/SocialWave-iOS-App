import Foundation

//struct model that keeps details about the suggested friend
struct SuggestedFriendDetails: Identifiable, Codable {
    let id: String
    let fullname: String?
    let username: String
    let profileImage: String?
    var pendingOrNot: Bool?
    
    init() {
        self.id = ""
        self.fullname = nil
        self.username = ""
        self.profileImage = nil
        self.pendingOrNot = nil
    }
}
