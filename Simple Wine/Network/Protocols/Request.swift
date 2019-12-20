import Foundation

protocol Request: Encodable {
    associatedtype ResponseType: Response
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: [String : Any?] { get }
    var headers: [String : String] { get }
    var baseURL: URL { get }
    func urlRequest() throws -> URLRequest
}

enum HTTPMethod: String {
    case get     = "GET"
    case post    = "POST"
    case delete  = "DELETE"
}
