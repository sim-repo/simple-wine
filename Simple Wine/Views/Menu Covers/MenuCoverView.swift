import UIKit

enum MenuCoverItem {
    case wineCard, logout
}

protocol MenuCoverViewDelegate {
    func didSelectItem(_ item:MenuCoverItem)
}

protocol MenuCoverView: UIView {
    var delegate: MenuCoverViewDelegate? { set get }
}
