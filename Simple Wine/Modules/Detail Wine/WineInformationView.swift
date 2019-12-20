//
//  WineInformationView.swift
//  Simple Wine
//
//  Created by Aynur Galiev on 22/04/2018.
//  Copyright © 2018 Aynur Galiev. All rights reserved.
//

import UIKit

protocol WineInformationViewDelegate: class {
    func likeDidTap()
}

final class WineInformationView: UIView {

    var descriptionText: String? {
        didSet {
            descriptionLabel.text = descriptionText
            invalidateIntrinsicContentSize()
        }
    }
    
    var articleText: String? {
        didSet {
            articleLabel.text = articleText
            invalidateIntrinsicContentSize()
        }
    }
    
    var price: Int? {
        didSet {
            priceContainerView.priceTitle = price != nil ? "\(price!)" : nil
            invalidateIntrinsicContentSize()
        }
    }
    
    var priceWithYourself: Int? {
        didSet {
            priceWithYourselfContainerView.priceTitle = priceWithYourself != nil ? "\(priceWithYourself!)" : nil
            invalidateIntrinsicContentSize()
        }
    }
    
    private var _isLiked: Bool = false
    var isWineLiked: Bool {
        get {
            return _isLiked
        }
        set {
            guard newValue != _isLiked else { return }
            _isLiked = newValue
            updateLikeButton()
        }
    }
    
    private func updateLikeButton() {
        let imageName = isWineLiked ? "LikeButton" : "DislikeButton"
        let tintColor = isWineLiked ? AppTheme.tint : UIColor.black
        likeButton.setImage(UIImage(named: imageName), for: .normal)
        likeButton.tintColor = tintColor
    }
    
    weak var delegate: WineInformationViewDelegate?
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = AppTheme.darkGray
        label.font = AppFont.geometriaRegular(ofSize: 15)
        label.layer.contentsGravity = CALayerContentsGravity.bottom
        label.numberOfLines = 0
        label.textAlignment = .left
        
        return label
    }()
    
    private let articleLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.geometriaMedium(ofSize: 15)
        label.textColor = AppTheme.darkGray
        return label
    }()
    
    private let priceContainerView: WinePriceView = {
        let winePriceView = WinePriceView()
        winePriceView.winePriceType = .inRestaraunt
        return winePriceView
    }()
    
    private let priceWithYourselfContainerView: WinePriceView = {
        let winePriceView = WinePriceView()
        winePriceView.winePriceType = .withYourself
        winePriceView.isHidden = true
        return winePriceView
    }()
    
    private let likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(likeWine), for: .touchUpInside)
        return button
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
        addSubview(descriptionLabel)
        addSubview(priceContainerView)
        addSubview(priceWithYourselfContainerView)
        addSubview(likeButton)
        addSubview(articleLabel)
        updateLikeButton()
    }
    
    @objc private func likeWine() {
        isWineLiked.toggle()
        delegate?.likeDidTap()
    }
    
    override var intrinsicContentSize: CGSize {
        
        var height: CGFloat = 0
        if let _ = descriptionText {
            descriptionLabel.sizeToFit()
            height += descriptionLabel.height + 10
        }
    
        if price != nil || priceWithYourself != nil {
            height += 60 + 10
        }
        
        height += 30
        return CGSize(width: width, height: height)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var offsetY: CGFloat = 0
        if let description = descriptionText {
            descriptionLabel.text = description
            descriptionLabel.sizeToFit()
            descriptionLabel.frame = CGRect(x: 6, y: 0, width: width - 6, height: descriptionLabel.height)
            offsetY += descriptionLabel.height + 10
        } else {
            descriptionLabel.frame = bounds
        }
        priceContainerView.frame = CGRect(x: 0, y: offsetY, width: width / 2, height: 40)
        priceWithYourselfContainerView.frame = CGRect(x: width / 2, y: offsetY, width: width / 2, height: 40)
        priceWithYourselfContainerView.contentMode = .right
        
        if price != nil || priceWithYourself != nil {
            offsetY += 40 + 10
        }
        
        articleLabel.sizeToFit()
        articleLabel.frame = CGRect(x: 0, y: offsetY, width: articleLabel.width, height: articleLabel.height)
        
        likeButton.frame = CGRect(x: self.width - 30, y: offsetY, width: 30, height: 30)
    }
}
