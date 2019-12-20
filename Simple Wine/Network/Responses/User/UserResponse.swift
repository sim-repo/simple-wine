import Foundation

final class User: Decodable {
    
//    private(set) var vinothequeID: String
    var token: String?
    
    enum UserRootCodingKeys: CodingKey {
//        case vinothequeID = "VINOTEKA"
    }
    
    required init(from decoder: Decoder) throws {
        let rootContainer = try decoder.container(keyedBy: UserRootCodingKeys.self)
//        vinothequeID = try rootContainer.decode(String.self, forKey: .vinothequeID)
    }
}
