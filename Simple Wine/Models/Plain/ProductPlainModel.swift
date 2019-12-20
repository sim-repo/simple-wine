import Foundation

struct ProductPlainModel: Decodable {
    
    let bitrix_id: Int
    let deeplink: String
    let name: String?
    let manufacturer: String?
    let price: Double?
    let hall_price: Double?
    let year: UInt?
    let volume: Double?
    let country: CountryPlainModel?
    let region: String?
    let sugar: String?
    let color: String?
    
}
