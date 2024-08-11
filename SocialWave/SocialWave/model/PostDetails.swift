import Foundation

//struct model that keeps details about the post
struct PostDetails: Identifiable, Codable {
    let id: String
    let text: String
    let username: String
    let userId: String
    let profileImage: String?
    let images: [String]
    var likes: [String]
    let createdAt: String
    
    init() {
        self.id = ""
        self.text = ""
        self.username = ""
        self.userId = ""
        self.profileImage = nil
        self.images = []
        self.likes = []
        self.createdAt = ""
    }
}
