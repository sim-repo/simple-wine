//
//  SystemDeviceRequest.swift
//  Simple Wine
//
//  Created by Ivan Babich on 24/10/2018.
//  Copyright © 2018 Aynur Galiev. All rights reserved.
//

import Foundation

final class SystemDeviceRequest: BaseWineshopRequest<SystemDevicePlainModel> {
    
    init () {
        super.init(vinothequeID: "9")
    }
    
    override var path: String {
        return "system/device/"
    }
    
}
