import Foundation

final class AvailableRegionsRequest: BaseWineshopRequest<[String]> {
    
    private var country: String = ""
    
    init(vinothequeID: String, country: String) {
        super.init(vinothequeID: vinothequeID)
        self.country = country
    }
    
    override var path: String {
        return "stores/\(self.vinothequeID)/regions/"
    }
    
    override func urlRequest() throws -> URLRequest {
        let countryQueryItem = URLQueryItem(name: "country", value: self.country)
        var components = URLComponents(string: "\(self.baseURL)/\(self.path)")!
        components.queryItems = [countryQueryItem]
        var request = URLRequest(url: components.url!)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
    
}
