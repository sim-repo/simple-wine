import Foundation

class BaseRequest<T: Response>: Request, Encodable {
    
    var path: String {
        fatalError("No base implementation")
    }
    
    var method: HTTPMethod {
        return .post
    }
    
    var parameters: [String : Any?] {
        return [:]
    }
    
    var headers: [String : String] {
        return ["Content-Type" : "application/json"]
    }
    
    var baseURL: URL {
        return Config.baseURL
    }
    
    func urlRequest() throws -> URLRequest {
        var request = URLRequest(url: self.baseURL)
        request.httpMethod = self.method.rawValue
        for header in self.headers {
            request.setValue(header.value, forHTTPHeaderField: header.key)
        }
        request.httpBody = try JSONEncoder().encode(self)
        return request
    }
    
    typealias ResponseType = T
    
    enum BaseRequestCodingKeys: String, CodingKey {
        case method = "method"
        case id = "id"
        case jsonrpc = "jsonrpc"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: BaseRequestCodingKeys.self)
        try container.encode(self.path, forKey: .method)
        try container.encode("1", forKey: .id)
        try container.encode("2.0", forKey: .jsonrpc)
    }
}
