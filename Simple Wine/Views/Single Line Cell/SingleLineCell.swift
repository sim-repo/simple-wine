import UIKit

final class SingleLineCell: UITableViewCell, CellConfigurable {
    
    // MARK: - Outlets
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var countLabel: UILabel!
    @IBOutlet private weak var titleLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var borderView: UIView!
    private var viewModel: SingleLineViewModel! {
        didSet { self.updateUI() }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        borderView.backgroundColor = AppTheme.line
    }
    
    func configure(with viewModel: CellViewModel) {
        guard let viewModel = viewModel as? SingleLineViewModel else { return }
        self.viewModel = viewModel
        self.titleLabel.font = viewModel.style.font()
        self.titleLeadingConstraint.constant = viewModel.style.titleLeadingMargin
        if viewModel.isLastCell {
            borderView.isHidden = false
        } else {
            borderView.isHidden = true
        }
    }
    
    private func updateUI() {
        self.titleLabel.text = viewModel?.titleText
        if let itemsCount = viewModel?.itemsCount {
            self.countLabel.text = "\(itemsCount)"
        } else {
            self.countLabel.text = nil
        }
    }
    
    override func addSubview(_ view: UIView) {
        if view is UIImageView {
            return
        }
        super.addSubview(view)
    }
    
    // MARK: - UITableViewCell
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.titleLabel.textColor = selected
            ? AppTheme.selected
            : AppTheme.unselected
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.viewModel = nil
    }
    
    static func cellHeight(for viewModel: SingleLineViewModel, width: CGFloat) -> CGFloat {
        return 64
    }
}

private extension SingleLineViewModel.Style {
    
    func font() -> UIFont {
        switch self {
        case .bold: return AppFont.charterBold(ofSize: 15.0)
        case .italic: return AppFont.charterItalic(ofSize: 15.0)
        }
    }
    
    var titleLeadingMargin: CGFloat {
        switch self {
        case .bold: return 37
        case .italic: return 60
        }
    }
}
