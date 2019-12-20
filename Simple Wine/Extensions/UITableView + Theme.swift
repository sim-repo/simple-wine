//
//  UITableView + Theme.swift
//  Simple Wine
//
//  Created by Dmitry Laenko on 02/07/2019.
//  Copyright © 2019 Aynur Galiev. All rights reserved.
//

import UIKit

extension UITableView {
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = AppTheme.background
    }
}
