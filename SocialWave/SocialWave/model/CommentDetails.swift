import Foundation

//struct model that keeps details about the comment
struct CommentDetails: Identifiable, Codable {
    let id: String
    let content: String
    let user: String
    let username: String?
    let post: String
    let profileImage: String?
    var likes: [String]
    let createdAt: String
    
    init() {
        self.id = ""
        self.content = ""
        self.user = ""
        self.username = ""
        self.post = ""
        self.profileImage = nil
        self.likes = []
        self.createdAt = ""
    }
}
