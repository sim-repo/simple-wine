import Foundation

final class AvailableFiltersRequest: BaseWineshopRequest<FiltersResponse> {
    
    var token = ""
    var deviceCode = ""
    
    init(token: String, deviceCode: String) {
        super.init(vinothequeID: Config.vinothequeId)
        self.token = token
        self.deviceCode = deviceCode
    }
    
    override var path: String {
        return "products/"
    }
    
    override func urlRequest() throws -> URLRequest {
        let components = URLComponents(string: "\(self.baseURL)/\(self.path)")!
        var request = URLRequest(url: components.url!)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("WineList", forHTTPHeaderField: "X-Develop-Device")
        request.setValue(token, forHTTPHeaderField: "X-User-Hash")
        request.setValue(deviceCode, forHTTPHeaderField: "X-Device-Code")
        
        return request
    }
    
}
