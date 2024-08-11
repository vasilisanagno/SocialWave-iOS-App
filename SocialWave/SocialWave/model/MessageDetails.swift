import Foundation

//struct model that keeps details about the message
struct MessageDetails: Identifiable, Codable {
    let id: String
    let sender: String
    let text: String?
    var createdAt: String
    
    init() {
        self.id = ""
        self.sender = ""
        self.text = nil
        self.createdAt = ""
    }
}
