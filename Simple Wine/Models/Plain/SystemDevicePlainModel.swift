//
//  SystemDevicePlainModel.swift
//  Simple Wine
//
//  Created by Ivan Babich on 24/10/2018.
//  Copyright © 2018 Aynur Galiev. All rights reserved.
//

import Foundation

struct SystemDevicePlainModel {
    let device: String
}

extension SystemDevicePlainModel: Decodable {
    
    enum SystemDeviceCodingKeys: String, CodingKey {
        case device = "device"
    }
    
    init(from decoder: Decoder) throws {
        let root = try decoder.container(keyedBy: SystemDeviceCodingKeys.self)
        device = try root.decode(String.self, forKey: .device)
    }
    
}
