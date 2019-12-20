//
//  WinePriceView.swift
//  Simple Wine
//
//  Created by Aynur Galiev on 3.марта.2018.
//  Copyright © 2018 Aynur Galiev. All rights reserved.
//

import Foundation
import UIKit

enum WinePriceType {
    case inRestaraunt, withYourself
    var title: String {
        switch self {
        case .inRestaraunt: return "В ресторане"
        case .withYourself: return "С собой"
        }
    }
}

final class WinePriceView: UIView {
    
    private struct Constants {
        static let horizontalSpacing: CGFloat = 13.0
    }
    
    private(set) lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = AppTheme.darkGray
        label.font = AppFont.geometriaMedium(ofSize: 15.0)
        label.backgroundColor = .clear
        return label
    }()
    
    private(set) lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.textColor = AppTheme.tint
        label.font = AppFont.charterBold(ofSize: 22.0)
        label.backgroundColor = .clear
        return label
    }()
    
    private(set) lazy var rubLabel: UILabel = {
        let label = UILabel()
        label.textColor = AppTheme.tint
        label.font = AppFont.geometriaRegular(ofSize: 22.0)
        label.backgroundColor = .clear
        return label
    }()
    
    var priceTitle: String? {
        didSet {
            if let priceStr = priceTitle, let price = Float(priceStr) {
                valueLabel.text = price.currency(fractionDigits: 0)
                titleLabel.text = winePriceType.title
            }
            else {
                valueLabel.text = nil
                titleLabel.text = nil
            }
            invalidateIntrinsicContentSize()
            setNeedsLayout()
        }
    }
    
    var winePriceType: WinePriceType = .inRestaraunt
    
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
        addSubview(valueLabel)
        addSubview(titleLabel)
    }
    
    override var intrinsicContentSize: CGSize {
        titleLabel.sizeToFit()
        valueLabel.sizeToFit()
        return CGSize(
            width: titleLabel.width + valueLabel.width + Constants.horizontalSpacing,
            height: max(titleLabel.height, valueLabel.height)
        )
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let text = NSAttributedString(string: winePriceType.title, attributes: [.font : titleLabel.font])
        let width = text.boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: height), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil).width
        if titleLabel.text == WinePriceType.inRestaraunt.title {
            titleLabel.frame = CGRect(
                x: 0,
                y: 5,
                width: width,
                height: self.height
            )
            valueLabel.sizeToFit()
            valueLabel.frame = CGRect(
                x: titleLabel.right + Constants.horizontalSpacing,
                y: 0,
                width: self.width - titleLabel.width,
                height: self.height
            )
            titleLabel.textAlignment = .left
            valueLabel.textAlignment = .left
        } else {
            titleLabel.frame = CGRect(
                x: 0,
                y: 5,
                width: width + 45,
                height: self.height
            )
            valueLabel.sizeToFit()
            valueLabel.frame = CGRect(
                x: titleLabel.right,
                y: 0,
                width: self.width - titleLabel.width,
                height: self.height
            )
            titleLabel.textAlignment = .right
            valueLabel.textAlignment = .right
        }
    }
    
}
