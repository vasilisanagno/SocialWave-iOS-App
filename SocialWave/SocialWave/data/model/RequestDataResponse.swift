import Foundation

//struct model that decodes data to take friends and sending/receiving requests from users
struct RequestDataResponse: Codable {
    var sending: [String]?
    var receiving: [String]
    var friends: [String]
}
