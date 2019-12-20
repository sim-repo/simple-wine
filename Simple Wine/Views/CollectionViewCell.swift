//
//  CollectionViewCell.swift
//  Simple Wine
//
//  Created by Ivan Babich on 02/11/2018.
//  Copyright © 2018 Aynur Galiev. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell, CollectionCellConfigurable {
    
    @IBOutlet var categoryLabel: UILabel!
    private var viewModel: CollectionViewCellModel! {
        didSet { self.updateUI() }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = AppTheme.background
        backgroundColor = AppTheme.background
    }
    
    private func updateUI() {
        self.categoryLabel.text = viewModel?.titleText
    }
    
    func configure(with viewModel: CollectionCellViewModel) {
        guard let viewModel = viewModel as? CollectionViewCellModel else { return }
        self.viewModel = viewModel
//        self.categoryLabel.font = viewModel.style.font()
    }
    
    static func cellHeight(for viewModel: CollectionCellViewModel, width: CGFloat) -> CGFloat {
        return 64
    }

}

private extension CollectionViewCellModel.Style {
    
    func font() -> UIFont {
        switch self {
        case .bold: return AppFont.charterBold(ofSize: 24.0)
        case .italic: return AppFont.charterItalic(ofSize: 20.0)
        }
    }
    
    var titleLeadingMargin: CGFloat {
        switch self {
        case .bold: return 37
        case .italic: return 60
        }
    }
    
}
