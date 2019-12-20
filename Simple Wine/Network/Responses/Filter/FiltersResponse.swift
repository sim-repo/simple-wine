import Foundation

struct FilterItems: Decodable {
    
    let slug: String
    let items: [FilterPlainModel]
    
    enum CodingKeys: String, CodingKey {
        case slug, items
    }
    
    init(from decoder: Decoder) throws {
        let root = try decoder.container(keyedBy: CodingKeys.self)
        slug = try root.decode(String.self, forKey: .slug)
        if slug == "price_sort" {
            items = try root.decode([FilterPlainModel].self, forKey: .items)
        } else if slug == "country" {
            items = try root.decode([FilterPlainModel].self, forKey: .items)
        } else {
            items = []
        }
    }
    
}

struct FiltersResponse: Decodable {
    
    let filters: [FilterItems]
    
    enum CodingKeys: String, CodingKey {
        case filters
    }
    
}
