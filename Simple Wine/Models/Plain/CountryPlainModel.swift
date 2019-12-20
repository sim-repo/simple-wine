import Foundation

struct CountryPlainModel {
    let name: String
    let flag: String?
    var regions: [String]
}

extension CountryPlainModel: Decodable {
   
    enum CountryCodingKeys: String, CodingKey {
        case name
        case flag
    }
    
    init(from decoder: Decoder) throws {
        let root = try decoder.container(keyedBy: CountryCodingKeys.self)
        name = try root.decode(String.self, forKey: .name)
        flag = try root.decode(String.self, forKey: .flag)
        regions = []
    }
    
}
