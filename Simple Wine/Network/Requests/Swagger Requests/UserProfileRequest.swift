import Foundation

final class UserProfileRequest: BaseRequest<BaseWineshopResponse<User>> {
    
    private(set) var token: String
    private(set) var deviceCode: String
    
    init(token: String, deviceCode: String) {
        self.token = token
        self.deviceCode = deviceCode
    }
    
    override var path: String {
        return "user/profile/"
    }
    
    override var method: HTTPMethod {
        return .get
    }
    
    override var baseURL: URL {
        return Config.swaggerBaseURL
    }
    
    override func urlRequest() throws -> URLRequest {
        
        var request = URLRequest(url: baseURL.appendingPathComponent(self.path))
        
        request.httpMethod = self.method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(token, forHTTPHeaderField: "X-User-Hash")
        request.setValue(deviceCode, forHTTPHeaderField: "X-Device-Code")

        print("header:\n\(request.allHTTPHeaderFields ?? [:])")
        return request
    }
    
    override func encode(to encoder: Encoder) throws { }
}
