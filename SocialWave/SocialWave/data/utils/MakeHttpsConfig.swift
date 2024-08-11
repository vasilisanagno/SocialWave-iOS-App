import Foundation
import Alamofire

//configurations to make the https connection with the server
extension SecCertificate {
    static func create(with data: Data) -> SecCertificate? {
        return SecCertificateCreateWithData(nil, data as CFData)
    }
}

struct MakeHttpsConfig {
    static func configurations() -> Session {
        guard let pathToCert = Bundle.main.path(forResource: "cert", ofType: "cer"),
        let certData = try? Data(contentsOf: URL(fileURLWithPath: pathToCert, isDirectory: false)),
        let certificate = SecCertificate.create(with: certData) else {
            fatalError("Failed to load certificate")
        }
        
        let manager = ServerTrustManager(evaluators: ["100.106.205.30" : PinnedCertificatesTrustEvaluator(
        certificates: [certificate], acceptSelfSignedCertificates: true, performDefaultValidation: true, validateHost: false)])
        
        let customSession = Session(serverTrustManager: manager)
        return customSession
    }
}
