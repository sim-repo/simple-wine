import Foundation

final class AuthTokenRequest: BaseRequest<BaseWineshopResponse<TokenResponse>> {
    
    private(set) var login: String
    private(set) var password: String
    private(set) var deviceCode: String
    private(set) var rememberSession: Bool // sets if session token should be endless
    
    init(login: String, password: String, deviceCode: String,  rememberSession: Bool = true) {
        self.login = login
        self.password = password
        self.deviceCode = deviceCode
        self.rememberSession = rememberSession
    }
    
    override var path: String {
        return "user/authorization/"
    }
    
    override var method: HTTPMethod {
        return .post
    }
    
    override var baseURL: URL {
        return Config.swaggerBaseURL
    }
    
    override func urlRequest() throws -> URLRequest {
        
        var request = URLRequest(url: baseURL.appendingPathComponent(self.path))
        
        request.httpMethod = self.method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue(deviceCode, forHTTPHeaderField: "X-Device-Code")
        
        let rawBody = "login=\(login)&password=\(password)&remember=\(rememberSession ? 1 : 0)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        request.httpBody = rawBody.data(using: .ascii, allowLossyConversion: false)
        return request
    }
    
    override func encode(to encoder: Encoder) throws { }
}
