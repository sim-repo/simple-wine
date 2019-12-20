import Foundation

final class ChangeFavoriteRequest: BaseWineshopRequest<String?> {
    
    var bitrix_id = ""
    var token = ""
    var deviceCode = ""
    var isRemove = true
    
    init(bitrix_id: String, token: String, deviceCode: String, isRemove: Bool) {
        super.init(vinothequeID: Config.vinothequeId)
        self.bitrix_id = bitrix_id
        self.token = token
        self.deviceCode = deviceCode
    }
    
    override var method: HTTPMethod {
        if isRemove {
            return .delete
        } else {
            return .post
        }
    }
    
    override var path: String {
        return "favorites/\(bitrix_id)/"
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
