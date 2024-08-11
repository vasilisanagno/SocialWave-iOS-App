import Foundation
import Alamofire

//class that implements the notification protocol functions
class NotificationProtocolImpl: NotificationProtocol {
    var customSession: Session
    
    init()  {
        customSession = MakeHttpsConfig.configurations()
    }
    
    //function that retrieves all the notifications for the current user
    func getNotifications(data: [String: String]) async throws -> Data {
        let url = Constants.BASE_URL + "socialwave/get-notifications"
        let token: String? = data["token"]
        let headers: HTTPHeaders = [
            "authorization" : "Bearer \(token!)"
        ]
        let response = try await customSession.request(url, method: .get, parameters: nil, headers: headers).validate().serializingData().value
        return response
    }
    
    //function that retrieves the number of unseen notifications
    func getNumOfUnseenNotifications(data: [String: String]) async throws -> Data {
        let url = Constants.BASE_URL + "socialwave/num-unseen-notifications"
        let token: String? = data["token"]
        let headers: HTTPHeaders = [
            "authorization" : "Bearer \(token!)"
        ]
        let response = try await customSession.request(url, method: .get, parameters: nil, headers: headers).validate().serializingData().value
        return response
    }
    
    //function that deletes all the notifications for the current user from the database
    func deleteNotifications(data: [String: String]) async throws -> Data {
        let url = Constants.BASE_URL + "socialwave/delete-notifications"
        let token: String? = data["token"]
        let headers: HTTPHeaders = [
            "authorization" : "Bearer \(token!)"
        ]
        let response = try await customSession.request(url, method: .delete, parameters: nil, headers: headers).validate().serializingData().value
        return response
    }
}
