import Foundation

struct PriceRange {
    
    let upperBound: Int?
    let lowerBound: Int?
    
    init(upperBound: Int?, lowerBound: Int?) {
        self.upperBound = upperBound
        self.lowerBound = lowerBound
    }
}

extension PriceRange: Encodable {
    
    enum PriceRangeKeys: String, CodingKey {
        case from = "from"
        case to = "to"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: PriceRangeKeys.self)
        try container.encodeIfPresent(self.lowerBound, forKey: .from)
        try container.encodeIfPresent(self.upperBound, forKey: .to)
    }
}

extension PriceRange {
    var stringRepresentation: String? {
        guard upperBound != nil || lowerBound != nil else { return nil }
        if upperBound != nil && lowerBound == nil {
            return "До \(upperBound!)"
        } else if upperBound == nil && lowerBound != nil {
            return "От \(lowerBound!)"
        } else {
            return "\(lowerBound!)-\(upperBound!)"
        }
    }
}
