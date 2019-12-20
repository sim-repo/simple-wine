//
//  Float+Utils.swift
//  Simple Wine
//
//  Created by Dmitry Laenko on 01/07/2019.
//  Copyright © 2019 Aynur Galiev. All rights reserved.
//

import Foundation

extension Float {
    
    func currency(fractionDigits: Int = 2) -> String? {
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.maximumFractionDigits = fractionDigits
        
        return formatter.string(from: NSNumber(value: self))
    }
    
}
