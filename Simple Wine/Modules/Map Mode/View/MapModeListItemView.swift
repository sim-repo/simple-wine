//
//  MapModeListItemView.swift
//  Simple Wine
//
//  Created by Dmitry Laenko on 03/10/2019.
//  Copyright © 2019 Aynur Galiev. All rights reserved.
//

import UIKit

class MapModeListItemView: UIView {
    
    @IBOutlet private weak var captionLabel: UILabel!
    @IBOutlet private weak var detailLabel: UILabel!
    @IBOutlet private weak var nextButton: UIButton!
    @IBOutlet private weak var loadingView: UIView!
    @IBOutlet private weak var lineView: UIView!

    var isLoading: Bool = true {
        didSet {
            isUserInteractionEnabled = !isLoading
            nextButton.isHidden = isLoading
            loadingView.isHidden = !isLoading
        }
    }
    var mapMode: WineMapMode = .classic {
        didSet {
            switch mapMode {
            case .classic:
                captionLabel.text = "Классическая"
                detailLabel.text = "Выбирайте по странам и регионам"
            case .price:
                captionLabel.text = "По цене"
                detailLabel.text = "Делайте открытия в любом ценовом диапазоне"
            }
        }
    }
    
    var clickCall: ((MapModeListItemView)->Void)?

    class func load(with: WineMapMode) -> MapModeListItemView{
        let view: MapModeListItemView = MapModeListItemView.fromXib()
        view.mapMode = with
        return view
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        lineView.backgroundColor = AppTheme.line
        captionLabel.textColor = AppTheme.selected
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap(_:))))
    }

    @objc func tap(_ recognizer: UIGestureRecognizer) {
        clickCall?(self)
    }
}
