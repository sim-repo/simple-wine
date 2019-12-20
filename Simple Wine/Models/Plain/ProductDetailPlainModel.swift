import Foundation

struct ProductDetailPlainModel: Decodable {
    
    let bitrix_id: Int
    let article: String
    let name: String
    let image: String?
    let year: Int
    let volume: Double
    let sugar_type: String?
    let color: String?
    let region: String?
    let manufacturer: String?
    let country: CountryPlainModel?
    let grapes: [String]?
    let price: Double?
    let hall_price: Double?
    let description: String?
    let russian_name: String?
    
    enum CodingKeys: String, CodingKey {
        case bitrix_id
        case article
        case name
        case russian_name = "ru_name"
        case manufacturer
        case image
        case year
        case volume
        case country
        case region
        case sugar_type = "sugar"
        case color
        case description
        case grapes = "grape"
        case price
        case hall_price
    }
    
}
