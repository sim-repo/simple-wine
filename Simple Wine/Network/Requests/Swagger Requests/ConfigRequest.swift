//
//  ConfigRequest.swift
//  Simple Wine
//
//  Created by Ivan Babich on 27/12/2018.
//  Copyright © 2018 Aynur Galiev. All rights reserved.
//

import Foundation

final class ConfigRequest: BaseWineshopRequest<ConfigPlainModel> {
    
    init() {
        super.init(vinothequeID: "9")
    }
    
    override var path: String {
        return "system/config/"
    }
    
}
