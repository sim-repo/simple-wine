import Foundation

final class AvailableWinesRequest: BaseWineshopRequest<AvailableProductsPlainModel> {
    
    var subCategoryId: UInt?
    var type: WineMapMode!
    var token = ""
    var deviceCode = ""
    var filters = [[String]]()
    var page = 1
    
    init(subCategoryId: UInt, type: WineMapMode, token: String, deviceCode: String, filters: [[String]], page: Int) {
        super.init(vinothequeID: Config.vinothequeId)
        self.subCategoryId = subCategoryId
        self.token = token
        self.deviceCode = deviceCode
        self.type = type
        self.filters = filters
        self.page = page
    }
    
    override var path: String {
        return "products/\(subCategoryId!)/"
    }
    
    override func urlRequest() throws -> URLRequest {
        var components = URLComponents(string: "\(self.baseURL)/\(self.path)")!
        components.queryItems = [
            URLQueryItem(name: "type_list", value: self.type.description),
            URLQueryItem(name: "show_filter", value: "N"),
            URLQueryItem(name: "limit", value: "50"),
            URLQueryItem(name: "page", value: String(describing: self.page))
        ]
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
