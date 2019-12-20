//
//  CollectionViewCellModel.swift
//  Simple Wine
//
//  Created by Ivan Babich on 02/11/2018.
//  Copyright © 2018 Aynur Galiev. All rights reserved.
//

import Foundation
import UIKit

struct CollectionViewCellModel: CollectionCellViewModel, Equatable {
    
    enum Style {
        case bold, italic
    }
    
    let titleText: String
    let style: Style
    
    init(text: String, style: Style = .bold) {
        self.titleText = text
        self.style = style
    }
    
    static var cellIdentifier: String {
        return String(describing: CollectionViewCell.self)
    }
    
    func height(for width: CGFloat) -> CGFloat {
        return CollectionViewCell.cellHeight(for: self, width: width)
    }
}
