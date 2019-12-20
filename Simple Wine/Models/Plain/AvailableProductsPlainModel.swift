import Foundation

struct AvailableProductsPlainModel: Decodable {
    
    let wines: [ProductPlainModel]?
    var page: Int = 0
    var total: Int = 0
    var count: Int = 0
    
    enum CodingKeys: String, CodingKey {
        case items
        case total_pages
        case page
        case total_products
    }
    
    init(from decoder: Decoder) throws {
        let root = try decoder.container(keyedBy: CodingKeys.self)
        wines = try root.decode([ProductPlainModel].self, forKey: .items)
        total = try root.decode(Int.self, forKey: .total_pages)
        let pageStr = try root.decode(String.self, forKey: .page)
        page = Int(pageStr) ?? total
        count = try root.decode(Int.self, forKey: .total_products)
    }
    
}
