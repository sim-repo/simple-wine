//
//  UITableViewCell + Theme.swift
//  Simple Wine
//
//  Created by Dmitry Laenko on 02/07/2019.
//  Copyright © 2019 Aynur Galiev. All rights reserved.
//

import UIKit

extension UITableViewCell {
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = AppTheme.background
        backgroundColor = AppTheme.background
    }
}
