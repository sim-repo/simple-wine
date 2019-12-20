//
//  AvailableCategories.swift
//  Simple Wine
//
//  Created by Ivan Babich on 18/10/2018.
//  Copyright © 2018 Aynur Galiev. All rights reserved.
//

import Foundation

final class AvailableCategoriesRequest: BaseWineshopRequest<[CategoryPlainModel]> {
    var categoryId: UInt?
    var token = ""
    var deviceCode = ""
    var type: WineMapMode!
    var filters = [[String]]()
    
    init(token: String, deviceCode: String, type: WineMapMode) {
        super.init(vinothequeID: "9")
        self.token = token
        self.deviceCode = deviceCode
        self.type = type
    }
    
    init(categoryId: UInt, token: String, filters: [[String]], type: WineMapMode) {
        super.init(vinothequeID: "9")
        self.categoryId = categoryId
        self.token = token
        self.filters = filters
        self.type = type
    }
    
    override var path: String {
        var url = "categories/"
        if let categoryId = self.categoryId {
            url += "\(categoryId)/"
        }
        return url
    }
    
    override func urlRequest() throws -> URLRequest {
        var components = URLComponents(string: "\(self.baseURL)/\(self.path)")!
        var queryItems = [URLQueryItem(name: "type_list", value: type.description)]
        for filter in filters {
            if (filter.count > 1) {
                queryItems.append(URLQueryItem(name: filter[0], value: filter[1]))
            }
        }
        components.queryItems = queryItems
        var request = URLRequest(url: components.url!)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("WineList", forHTTPHeaderField: "X-Develop-Device")
        request.setValue(token, forHTTPHeaderField: "X-User-Hash")
        request.setValue(deviceCode, forHTTPHeaderField: "X-Device-Code")
        
        return request
    }
    
}
