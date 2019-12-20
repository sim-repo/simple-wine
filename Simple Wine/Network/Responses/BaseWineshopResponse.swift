import Foundation

class BaseWineshopResponse<T: Decodable>: Response {
    
    typealias ResponseType = T
    
    private enum Status: String {
        case error
        case success
        
        init(string: String) throws {
            switch string.lowercased() {
            case "success": self = .success
            case "error": self = .error
            default: throw SWError.parseError
            }
        }
    }
    
    private(set) var value: T?
    
    enum BaseWineshopCodingKeys: String, CodingKey {
        case data = "data"
        case status = "status"
    }
    
    required init(from decoder: Decoder) throws {
        let resultContainer = try decoder.container(keyedBy: BaseWineshopCodingKeys.self)
        let status = try resultContainer.decode(String.self, forKey: .status)
        let responseStatus = try Status(string: status)
        if responseStatus == .success {
            self.value = try resultContainer.decode(T?.self, forKey: .data)
        } else {
            throw SWError.parseError
        }
    }
}
