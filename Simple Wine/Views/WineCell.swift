import UIKit

class WineCell: UITableViewCell {

    // MARK: - Outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - UITableViewCell
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        self.titleLabel.textColor = selected
            ? AppTheme.selected
            : AppTheme.textFieldText
    }

}
