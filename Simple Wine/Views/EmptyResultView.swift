//
//  EmptyResultView.swift
//  Simple Wine
//
//  Created by Aynur Galiev on 29.03.2018.
//  Copyright © 2018 Aynur Galiev. All rights reserved.
//

import UIKit

protocol EmptyResultViewDelegate {
    func tryAgainTapped(emptyResultView: EmptyResultView)
}

final class EmptyResultView: UIView {

    enum State {
        case isLoading
        case error(String)
    }
    
    @IBOutlet weak var errorTextLabel: UILabel!
    @IBOutlet weak var tryAgainButton: UIButton!
    @IBOutlet weak var progressIndicatorView: UIActivityIndicatorView!
    
    var state: State = .isLoading {
        didSet {
            updateUI()
        }
    }
    
    var delegate: EmptyResultViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    private func initialize() {
        backgroundColor = AppTheme.background
    }
    
    private func updateUI() {
        switch state {
        case .isLoading:
            errorTextLabel.isHidden = true
            tryAgainButton.isHidden = true
            progressIndicatorView.startAnimating()
        case .error(let text):
            errorTextLabel.text = text
            errorTextLabel.isHidden = false
            tryAgainButton.isHidden = false
            progressIndicatorView.stopAnimating()
        }
    }
    
    @IBAction func tryAgain(_ sender: UIButton) {
        delegate?.tryAgainTapped(emptyResultView: self)
    }
    
}
