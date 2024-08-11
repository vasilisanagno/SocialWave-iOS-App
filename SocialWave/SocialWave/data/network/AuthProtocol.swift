import Foundation

//protocol that contains functions that communicates with server with requests for authentication of the user
protocol AuthProtocol {
    func checkLoginData(data: [String: String]) async throws -> Data
    func sendOTP(data: [String: String]) async throws -> Data
    func signupUser(data: [String: Any]) async throws -> Data
    func checkEmailAndSendOTP(data: [String: String]) async throws -> Data
    func checkOTP(data: [String: Any]) async throws -> Data
    func updatePassword(data: [String: String]) async throws -> Data
    func autoLogin(data: [String: String]) async throws -> Data
    func deleteUser(data: [String: String]) async throws -> Data
}
