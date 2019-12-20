import Foundation

final class FetchWineRequest: BaseWineshopRequest<ProductDetailPlainModel> {
    
    private(set) var bitrix_id: Int = 0
    private(set) var token = ""
    private(set) var deviceCode = ""
    
    init(bitrix_id: Int, token: String, deviceCode: String) {
        super.init(vinothequeID: Config.vinothequeId)
        self.bitrix_id = bitrix_id
        self.token = token
        self.deviceCode = deviceCode
    }
    
    override var path: String {
        return "product/\(bitrix_id)"
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


