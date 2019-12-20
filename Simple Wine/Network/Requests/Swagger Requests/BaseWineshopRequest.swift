import Foundation

enum WineshopCardType: Int16 {
    case classic = 1
    case price
    
    var description : String {
        get {
            switch(self) {
            case .classic:
                return "classic"
            case .price:
                return "price"
            }
        }
    }
}

class BaseWineshopRequest<T: Decodable>: BaseRequest<BaseWineshopResponse<T>> {
    
    private(set) var vinothequeID: String
    
    init(vinothequeID: String) {
        self.vinothequeID = vinothequeID
    }
    
    override var method: HTTPMethod {
        return .get
    }
    
    override var baseURL: URL {
        return Config.swaggerBaseURL
    }
    
    override func urlRequest() throws -> URLRequest {
        var request = URLRequest(url: URL(string: "\(self.baseURL)/\(self.path)")!)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
    
    override func encode(to encoder: Encoder) throws { }
}
