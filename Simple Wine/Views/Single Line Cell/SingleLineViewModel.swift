import Foundation
import UIKit

struct SingleLineViewModel: CellViewModel, Equatable {

    enum Style {
        case bold, italic
    }
    
    let titleText: String
    let itemsCount: UInt?
    let style: Style
    let isLastCell: Bool
    
    init(text: String, itemsCount: UInt?, isLastCell: Bool, style: Style = .bold) {
        self.titleText = text
        self.itemsCount = itemsCount
        self.isLastCell = isLastCell
        self.style = style
    }
    
    static var cellIdentifier: String {
        return String(describing: SingleLineCell.self)
    }
    
    func height(for width: CGFloat) -> CGFloat {
        return SingleLineCell.cellHeight(for: self, width: width)
    }
}
