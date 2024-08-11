import Foundation
import Alamofire

//class that implements the auth protocol functions
class AuthProtocolImpl: AuthProtocol {
    var customSession: Session
    
    init()  {
        customSession = MakeHttpsConfig.configurations()
    }
    
    //function that checks the data in two fields(email and password)
    //and makes the login of the user if they are correct
    func checkLoginData(data: [String: String]) async throws -> Data {
        let url = Constants.BASE_URL + "socialwave/login"
        
        let response = try await customSession.request(url, method: .post,parameters: data).validate().serializingData().value
        return response
    }
    
    //function that sends otp through the server in the email that typed
    //the user to check if it is correct and there is
    func sendOTP(data: [String: String]) async throws -> Data {
        let url = Constants.BASE_URL + "socialwave/send-otp"
        
        let response = try await customSession.request(url, method: .post,parameters: data).validate().serializingData().value
        return response
    }
    
    //function that makes the signup of a new user in the app
    func signupUser(data: [String: Any]) async throws -> Data {
        let url = Constants.BASE_URL + "socialwave/signup"
        
        let response = try await customSession.request(url, method: .post,parameters: data).validate().serializingData().value
        return response
    }
    
    //function that checks the email in the reset password and if it is correct sends otp to verify it
    func checkEmailAndSendOTP(data: [String: String]) async throws -> Data {
        let url = Constants.BASE_URL + "socialwave/check-email"
        var responseOTP: Data = Data()
        
        let response = try await customSession.request(url, method: .post,parameters: ["email": data["email"] ?? ""]).validate().serializingDecodable(ApiResponse.self).value
        
        if response.success {
            responseOTP = try await sendOTP(data: data)
        }
        return responseOTP
    }
    
    //function that checks if the otp that type the user is correct or not
    func checkOTP(data: [String: Any]) async throws -> Data {
        let url = Constants.BASE_URL + "socialwave/check-otp"
        
        let response = try await customSession.request(url, method: .post,parameters: data).validate().serializingData().value
        return response
    }
    
    //function that updates the password of the user
    func updatePassword(data: [String: String]) async throws -> Data {
        let url = Constants.BASE_URL + "socialwave/change-password"
        
        let response = try await customSession.request(url, method: .post,parameters: data).validate().serializingData().value
        return response
    }
    
    //function that makes the auto login when the user have already connected
    func autoLogin(data: [String: String]) async throws -> Data {
        let url = Constants.BASE_URL + "socialwave/verify-user"
        
        let response = try await customSession.request(url, method: .post,parameters: data).validate().serializingData().value
        return response
    }
    
    //function that deletes the user account
    func deleteUser(data: [String: String]) async throws -> Data {
        let url = Constants.BASE_URL + "socialwave/delete-user"
        let token: String? = data["token"]
        let headers: HTTPHeaders = [
            "authorization" : "Bearer \(token!)"
        ]
        let response = try await customSession.request(url, method: .delete, parameters: nil, headers: headers).validate().serializingData().value
        return response
    }
}
