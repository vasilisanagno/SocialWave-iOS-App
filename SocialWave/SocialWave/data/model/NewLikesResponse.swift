import Foundation

//struct model that decodes data to take renewed likes
struct NewLikesResponse: Codable {
    let likes: [String]
}
