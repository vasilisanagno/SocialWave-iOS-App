import Foundation

//struct model that decodes data from many https requests
struct ApiResponse: Codable {
    let success: Bool
    let message: String?
    let token: String?
    
    init() {
        self.success = false
        self.message = nil
        self.token = nil
    }
}
