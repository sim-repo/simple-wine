import Foundation

final class FilterWinesRequest: BaseRequest<FilterWinesResponse> {
    
    private(set) var filterOptions: FilterWinesOptions
    
    init(filterOptions: FilterWinesOptions) {
        self.filterOptions = filterOptions
    }
    
    override var path: String {
        return "filter_items"
    }

    enum FilterWinesParamsCodingKeys: String, CodingKey {
        case params = "params"
    }
    
    enum FilterWinesRequestCodingKeys: String, CodingKey {
        case countries = "countries"
        case priceRanges = "price_ranges"
    }
    
    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var rootContainer = encoder.container(keyedBy: FilterWinesParamsCodingKeys.self)
        var paramsContainer = rootContainer.nestedContainer(keyedBy: FilterWinesRequestCodingKeys.self, forKey: .params)
        try paramsContainer.encodeIfPresent(self.filterOptions.countries, forKey: .countries)
        try paramsContainer.encodeIfPresent(self.filterOptions.priceRanges, forKey: .priceRanges)
    }
    
}

