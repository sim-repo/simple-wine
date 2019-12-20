//
//  WinePropertyView.swift
//  Simple Wine
//
//  Created by Aynur Galiev on 28.февраля.2018.
//  Copyright © 2018 Aynur Galiev. All rights reserved.
//

import UIKit

final class WinePropertyView: UIView {

     let imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = AppTheme.darkGray
        label.font = AppFont.geometriaRegular(ofSize: 15.0)
        label.numberOfLines = 0
        label.backgroundColor = .clear
        label.layer.contentsGravity = CALayerContentsGravity.bottom
        return label
    }()
    
    var winePropertyItem: WinePropertyItem? {
        didSet {
            titleLabel.text = winePropertyItem?.text
            imageView.image = winePropertyItem?.image
            invalidateIntrinsicContentSize()
            setNeedsLayout()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    private func initialize() {
        clipsToBounds = true
        backgroundColor = .clear
        addSubview(imageView)
        addSubview(titleLabel)
    }
    
    override var intrinsicContentSize: CGSize {
        let size = titleLabel.sizeThatFits(CGSize(width: width - 18 - 12, height: .greatestFiniteMagnitude))
        return CGSize(
            width: height,
            height: max(size.height, 18)
        )
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = CGRect(
            x: 0,
            y: ceil((height - 18) / 2),
            width: 18.0,
            height: 18.0
        )
        titleLabel.sizeToFit()
        titleLabel.frame = CGRect(
            x: imageView.right + 12,
            y: 0,
            width: width - 18 - 12,
            height: height
        )
    }
    
}
