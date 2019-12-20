//
//  CollectionViewCell.swift
//  Simple Wine
//
//  Created by Dmitry Laenko on 03/10/2019.
//  Copyright © 2019 Aynur Galiev. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var captionLabel: UILabel!
    
    override var isSelected: Bool {
        didSet {
            captionLabel.font = isSelected ? AppFont.geometriaMedium(ofSize: 16) : AppFont.geometriaLight(ofSize: 16)
            captionLabel.textColor = isSelected ? AppTheme.selected : AppTheme.unselected
        }
    }
    
    var caption: String? {
        didSet { captionLabel.text = caption }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    static func width(_ s: String? ) -> CGFloat {
        guard let s = s else { return 10 }
        return NSAttributedString(string: s, attributes: [.font : AppFont.geometriaMedium(ofSize: 16)]).size().width + 10
    }
    
    static var nib: UINib? {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: CollectionViewCell.self)
    }
}
