//
//  DetailedSingleLineCell.swift
//  Simple Wine
//
//  Created by Aynur Galiev on 13.марта.2018.
//  Copyright © 2018 Aynur Galiev. All rights reserved.
//

import UIKit

final class DetailedSingleLineCell: UITableViewCell, CellConfigurable {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var detailTitleLabel: UILabel!
    
    private var viewModel: DetailedSingleViewModel! {
        didSet { updateUI() }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    private func updateUI() {
        guard let viewModel = viewModel else { return }
        titleLabel.text = viewModel.titleText
        detailTitleLabel.text = viewModel.priceText
        if viewModel.canEdit {
            if viewModel.selected {
//                deleteButton.isHidden = false
            } else {
//                deleteButton.isHidden = true
            }
        } else {
//            deleteButton.isHidden = true
        }
        titleLabel.textColor = viewModel.selected
            ? AppTheme.selected
            : AppTheme.textFieldText
        detailTitleLabel.textColor = viewModel.selected
            ? AppTheme.selected
            : AppTheme.textFieldText
        layoutIfNeeded()
    }
    
    func configure(viewModel: DetailedSingleViewModel) {
        self.viewModel = viewModel
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        titleLabel.textColor = selected
            ? AppTheme.selected
            : AppTheme.textFieldText
        detailTitleLabel.textColor = selected
            ? AppTheme.selected
            : AppTheme.textFieldText
    }
    
    func configure(with viewModel: CellViewModel) {
        guard let viewModel = viewModel as? DetailedSingleViewModel else { return }
        self.viewModel = viewModel
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        viewModel = nil
    }
    
    static func cellHeight(for viewModel: DetailedSingleViewModel, width: CGFloat) -> CGFloat {
        return 64
    }
}
