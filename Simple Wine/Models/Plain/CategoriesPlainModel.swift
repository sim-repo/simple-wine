import Foundation

struct CategoryPlainModel: Decodable {
    
    let category_id: UInt
    let name: String?
    let deeplink: String
    let count: UInt?
    
}
