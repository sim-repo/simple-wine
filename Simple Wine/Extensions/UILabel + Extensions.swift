//
//  UILabel + Extensions.swift
//  Simple Wine
//
//  Created by Aynur Galiev on 22/04/2018.
//  Copyright © 2018 Aynur Galiev. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    
    var isEmpty: Bool {
        return text == nil || text == ""
    }
}
