import Foundation

final class AvailableCountriesRequest: BaseWineshopRequest<[CountryPlainModel]> {
    
    var subCategoryId: UInt?
    var filters = [[String]]()
    var token = ""
    var deviceCode = ""
    
    init(vinothequeID: String, subCategoryId: UInt, filters: [[String]], token: String, deviceCode: String) {
        super.init(vinothequeID: vinothequeID)
        self.subCategoryId = subCategoryId
        self.filters = filters
        self.token = token
        self.deviceCode = deviceCode
    }
    
    override var path: String {
        return "categories/\(subCategoryId!)"
    }
    
    override func urlRequest() throws -> URLRequest {
        var components = URLComponents(string: "\(self.baseURL)/\(self.path)")!
        for filter in filters {
            if (filter.count > 1) {
                components.queryItems?.append(URLQueryItem(name: filter[0], value: filter[1]))
            }
        }
        var request = URLRequest(url: components.url!)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("WineList", forHTTPHeaderField: "X-Develop-Device")
        request.setValue(token, forHTTPHeaderField: "X-User-Hash")
        request.setValue(deviceCode, forHTTPHeaderField: "X-Device-Code")
        
        return request
    }
    
}
