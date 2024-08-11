import Foundation

//struct model that keeps details about the user
struct UserDetails: Identifiable, Codable {
    let id: String
    let fullname: String?
    let username: String
    let description: String?
    let profileImage: String?
    var sending: [String]
    var receiving: [String]
    var friends: [String]
    let posts: [String]
    
    init() {
        self.id = ""
        self.fullname = nil
        self.username = ""
        self.description = nil
        self.profileImage = nil
        self.receiving = []
        self.sending = []
        self.friends = []
        self.posts = []
    }
}
