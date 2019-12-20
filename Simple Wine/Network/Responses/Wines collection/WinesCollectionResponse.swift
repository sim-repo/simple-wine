import Foundation

final class WinesCollectionResponse: Response {
 
    typealias ResponseType = [ProductPlainModel]
    
    private(set) var wines: [ProductPlainModel]?
    private(set) var page: Int = 0
    private(set) var pageCount: Int = 0
    private(set) var perPage: Int = 0
    
    enum FilterWinesRootCodingKeys: String, CodingKey {
        case result = "result"
    }
    
    enum FilterWinesResultCodingKeys: String, CodingKey {
        case items = "items"
        case page = "page"
        case pageCount = "page_count"
        case perPage = "per_page"
    }
    
    required init(from decoder: Decoder) throws {
        let rootContainer = try decoder.container(keyedBy: FilterWinesRootCodingKeys.self)
        let resultContainer = try rootContainer.nestedContainer(keyedBy: FilterWinesResultCodingKeys.self, forKey: .result)
        self.page = try resultContainer.decode(Int.self, forKey: .page)
        self.perPage = try resultContainer.decode(Int.self, forKey: .perPage)
        self.pageCount = try resultContainer.decode(Int.self, forKey: .pageCount)
        self.wines = try resultContainer.decode([ProductPlainModel].self, forKey: .items)
    }
}
