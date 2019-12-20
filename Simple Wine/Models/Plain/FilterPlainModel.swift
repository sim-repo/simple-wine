struct FilterPlainModel: Decodable {
    
    let name: String
    let value: String
    let count: UInt
    
    enum CodingKeys: String, CodingKey {
        case name
        case value
        case count
    }
    
}
