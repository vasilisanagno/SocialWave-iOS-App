import Foundation
import KeychainSwift

//repository class for authentication of the user and takes the data from the auth protocol and decode them 
class AuthRepository {
    private let service: AuthProtocol
    
    init(service: AuthProtocol) {
        self.service = service
    }
    
    func login(email: String, password: String) async throws -> (Bool, UserDetails) {
        let data = try await service.checkLoginData(data: [
            "email": email, "password": password
        ])
        let response = try JSONDecoder().decode(ApiResponse.self, from: data)
        
        if response.success {
            if response.token != "" {
                let keychain = KeychainSwift()
                keychain.set(response.token!, forKey: "jwt")
            }
            let user = try await verifyUser(token: response.token!)
            return (response.success, user)
        }
        return (response.success, UserDetails())
    }
    
    func signupWithOTPFirst(email: String, username: String, process: String) async throws -> ApiResponse {
        let data = try await service.sendOTP(data: [
            "email": email, "username": username, "process": process
        ])
        let response = try JSONDecoder().decode(ApiResponse.self, from: data)
        return response
    }
    
    func signupAfterOTPCheck(
        otp: Int64,
        email: String,
        username: String,
        password: String
    ) async throws -> ApiResponse {
        let data = try await service.signupUser(data: [
            "otp": otp, "email": email,
            "username": username, "password": password
        ])
        let response = try JSONDecoder().decode(ApiResponse.self, from: data)
        return response
    }
    
    func checkEmailOfTheUser(
        email: String
    ) async throws -> ApiResponse {
        let data = try await service.checkEmailAndSendOTP(data: [
            "email": email,
            "process": "resetPassword"
        ])
        var response: ApiResponse = ApiResponse()
        if !data.isEmpty {
            response  = try JSONDecoder().decode(ApiResponse.self, from: data)
        }
        return response
    }
    
    func checkOTPOfTheUser(
        otp: Int64,
        email: String
    ) async throws -> ApiResponse {
        let data = try await service.checkOTP(data: [
            "otp": otp,
            "email": email
        ])
        let response = try JSONDecoder().decode(ApiResponse.self, from: data)
        return response
    }
    
    func changePasswordOfTheUser(
        email: String,
        password: String
    ) async throws {
        _ = try await service.updatePassword(data: [
            "email": email,
            "password": password
        ])
    }
    
    func verifyUser(
        token: String
    ) async throws -> UserDetails {
        let response = try await service.autoLogin(data: [
            "token": token
        ])
        let user = try JSONDecoder().decode(UserDetails.self, from: response)
        return user
    }
    
    func deleteUser(
        token: String
    ) async throws {
        _ = try await service.deleteUser(data: [
            "token": token
        ])
    }
}
