import UIKit

class WinesMainCell: UITableViewCell, CellConfigurable {
    
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    private var viewModel: WinesMainViewModel! {
        didSet { self.updateUI() }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    func configure(with viewModel: CellViewModel) {
        guard let viewModel = viewModel as? WinesMainViewModel else { return }
        self.viewModel = viewModel
    }
    
    private func updateUI() {
        self.yearLabel.text = viewModel?.yearText
        self.titleLabel.text = viewModel?.titleText
        self.priceLabel.text = viewModel?.priceText
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
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.viewModel = nil
    }
    
    static func cellHeight(for viewModel: WinesMainViewModel, width: CGFloat) -> CGFloat {
        return 64
    }
    
}
