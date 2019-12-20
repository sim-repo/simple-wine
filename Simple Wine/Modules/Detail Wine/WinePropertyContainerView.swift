//
//  WinePropertyContainerView.swift
//  Simple Wine
//
//  Created by Aynur Galiev on 21/04/2018.
//  Copyright © 2018 Aynur Galiev. All rights reserved.
//

import UIKit

struct WinePropertyItem {
    
    enum WineProperty {
        case color, sugar, grapes, country
    }
    
    var wineProperty: WineProperty?
    var image: UIImage?
    var value: String?
    
//    var title: String {
//        guard let property = wineProperty else { return "" }
//        switch property {
//        case .color: return "Цвет:"
//        case .sugar: return "Сахар:"
//        case .grapes: return "Виноград:"
//        case .country: return "Страна:"
//        }
//    }
    
    var text: String {
        guard let _ = wineProperty else { return "" }
        return "\(value ?? "")"
    }
    
}

final class WinePropertyContainerView: UIView {

    var wineProperties: [WinePropertyItem] = [] {
        didSet {
            setNeedsLayout()
        }
    }
    
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    private var winePropertyViews: [WinePropertyView] = []
    
    // Private
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.geometriaMedium(ofSize: 15)
        label.textColor = AppTheme.darkGray
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    private func initialize() {
        addSubview(titleLabel)
        setNeedsLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.sizeToFit()
        titleLabel.frame = CGRect(x: 0, y: 50, width: width, height: titleLabel.height)
        if wineProperties.count > winePropertyViews.count {
            for _ in 0..<(wineProperties.count - winePropertyViews.count) {
                let view = WinePropertyView()
                winePropertyViews.append(view)
                addSubview(view)
            }
        }
        if wineProperties.count < winePropertyViews.count {
            let views = winePropertyViews[wineProperties.count..<winePropertyViews.count]
            winePropertyViews.removeLast(winePropertyViews.count - wineProperties.count)
            views.forEach { $0.removeFromSuperview() }
        }
        var lastView: UIView = titleLabel
        for i in 0..<wineProperties.count {
            winePropertyViews[i].winePropertyItem = wineProperties[i]
            winePropertyViews[i].invalidateIntrinsicContentSize()
            var y: CGFloat = 20.5
//            switch i {
//            case 0:
//                y = 25
//                break
//            case 1:
//                y = 19
//                break
//            case 2:
//                y = 21
//                break
//            case 3:
//                y = 20.5
//                break
//            default: break
//            }
            if winePropertyViews[i].intrinsicContentSize.height > 0 {
                let frame = CGRect(
                    x: 0,
                    y: lastView.bottom + y,
                    width: width,
                    height: 0
                )
                winePropertyViews[i].frame = frame
                
                // calculate height after width was set
                winePropertyViews[i].frame = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: winePropertyViews[i].intrinsicContentSize.height)
                
                lastView = winePropertyViews[i]
            }
        }
    }
    
}
