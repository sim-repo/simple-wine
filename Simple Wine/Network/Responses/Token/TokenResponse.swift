import Foundation

struct TokenResponse: Codable {
    
    private(set) var token: String?
    
    enum CodingKeys: String, CodingKey {
        case token
    }
    
    init(from decoder: Decoder) throws {
        let containter = try decoder.container(keyedBy: CodingKeys.self)
        token = try containter.decodeIfPresent(String.self, forKey: .token)
    }
}
