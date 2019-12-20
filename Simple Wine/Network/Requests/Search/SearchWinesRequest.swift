import Foundation

final class SearchWinesRequest: BaseRequest<WinesCollectionResponse> {
    
    private(set) var query: String = ""
    
    init(query: String) {
        self.query = query
    }
    
    override var path: String {
        return "search"
    }
    
    enum SearchWinesParamsCodingKeys: String, CodingKey {
        case params = "params"
    }
    
    enum SearchWinesRequestCodingKeys: String, CodingKey {
        case query = "query"
    }
    
    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var rootContainer = encoder.container(keyedBy: SearchWinesParamsCodingKeys.self)
        var paramsContainer = rootContainer.nestedContainer(keyedBy: SearchWinesRequestCodingKeys.self, forKey: .params)
        try paramsContainer.encode(self.query, forKey: .query)
    }
}
