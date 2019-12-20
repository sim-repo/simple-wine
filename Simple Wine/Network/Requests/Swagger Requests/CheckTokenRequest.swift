import Foundation

final class CheckTokenRequest: BaseRequest<BaseWineshopResponse<TokenResponse>> {
    
    private(set) var token: String
    private(set) var deviceCode: String
    
    init(token: String, deviceCode: String) {
        self.token = token
        self.deviceCode = deviceCode
    }
    
    override var path: String {
        return "products/"
    }
    
    override var method: HTTPMethod {
        return .get
    }
    
    override var baseURL: URL {
        return Config.swaggerBaseURL
    }
    
    override func urlRequest() throws -> URLRequest {
        var components = URLComponents(string: "\(self.baseURL)/\(self.path)")!
        components.queryItems = [
            URLQueryItem(name: "show_filter", value: "N")
        ]
        var request = URLRequest(url: components.url!)
        
        request.httpMethod = self.method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(token, forHTTPHeaderField: "X-User-Hash")
        request.setValue(deviceCode, forHTTPHeaderField: "X-Device-Code")
        
        return request
    }
    
    override func encode(to encoder: Encoder) throws { }
}
