//
//  AvailablePricesRequest.swift
//  Simple Wine
//
//  Created by Ivan Babich on 18/11/2018.
//  Copyright © 2018 Aynur Galiev. All rights reserved.
//

import Foundation

final class AvailablePricesRequest: BaseWineshopRequest<[String]> {
    
    var subCategoryId: UInt?
    var token = ""
    var deviceCode = ""
    
    override var path: String {
        return "stores/\(self.vinothequeID)/prices/?category=\(subCategoryId!)"
    }
    
    init(vinothequeID: String, subCategoryId: UInt, token: String, deviceCode: String) {
        super.init(vinothequeID: vinothequeID)
        self.subCategoryId = subCategoryId
        self.token = token
        self.deviceCode = deviceCode
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
