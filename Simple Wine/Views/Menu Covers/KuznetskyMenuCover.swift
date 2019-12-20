
import UIKit

class KuznetskyMenuCover: UIView, MenuCoverView {

    var delegate: MenuCoverViewDelegate?
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
        delegate?.didSelectItem(.logout)
    }
    
    @IBAction func wineCardButtonPressed(_ sender: Any) {
        delegate?.didSelectItem(.wineCard)
    }

}
