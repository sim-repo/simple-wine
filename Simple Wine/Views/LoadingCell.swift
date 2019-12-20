//
//  LoadingCell.swift
//  Simple Wine
//
//  Created by Aynur Galiev on 26.марта.2018.
//  Copyright © 2018 Aynur Galiev. All rights reserved.
//

import UIKit

final class LoadingCell: UITableViewCell, CellConfigurable {
    
    @IBOutlet private weak var loadButton: UIButton!
    @IBOutlet private weak var loadingIndicatorView: UIActivityIndicatorView!
    @IBOutlet private weak var tryAgainContainerView: UIView!
    private var viewModel: LoadingCellViewModel! {
        didSet { updateUI() }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        loadButton.layer.borderWidth = 1
        loadButton.layer.borderColor = AppTheme.tint.cgColor
        loadButton.layer.cornerRadius = 5
    }
    
    private func updateUI() {
        guard let viewModel = viewModel else { return }
        tryAgainContainerView.isHidden = viewModel.state == .inProgress
        if viewModel.state == .inProgress {
            loadingIndicatorView.startAnimating()
        } else {
            loadingIndicatorView.stopAnimating()
        }
    }
    
    func configure(with viewModel: CellViewModel) {
        guard let viewModel = viewModel as? LoadingCellViewModel else { return }
        self.viewModel = viewModel
        self.viewModel.stateChanged = { state in
            self.updateUI()
        }
    }
    
    override func addSubview(_ view: UIView) {
        if view is UIImageView {
            return
        }
        super.addSubview(view)
    }
    
    @IBAction func tryAgain(sender: UIButton) {
        viewModel.tryAgainAction?()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.viewModel = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if bounds.size.height <= loadingIndicatorView.height {
            loadingIndicatorView.alpha = bounds.size.height/loadingIndicatorView.height
        } else {
            loadingIndicatorView.alpha = 1
        }
    }
    
    static func cellHeight(for viewModel: LoadingCellViewModel, width: CGFloat) -> CGFloat {
        return 64
    }
}
