import Foundation

//struct model that decodes data to extract the user and post details
struct UserDataResponse: Codable {
    var user: UserDetails
    var posts: [PostDetails]
}
