//
//  ConfigPlainModel.swift
//  Simple Wine
//
//  Created by Ivan Babich on 27/12/2018.
//  Copyright © 2018 Aynur Galiev. All rights reserved.
//

import Foundation

struct ConfigPlainModel: Decodable {
    
    let baseURL: String?
    let staticURL: String?
    
    enum CodingKeys: String, CodingKey {
        case baseURL = "base_url"
        case staticURL = "static_url"
    }
    
    init(from decoder: Decoder) throws {
        let root = try decoder.container(keyedBy: CodingKeys.self)
        baseURL = try root.decode(String.self, forKey: .baseURL)
        staticURL = try root.decode(String.self, forKey: .staticURL)
    }
    
}
