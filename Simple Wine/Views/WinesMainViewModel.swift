import Foundation
import UIKit

struct WinesMainViewModel: CellViewModel, Equatable {
    
    enum Style {
        case bold, italic
    }
    
    let yearText: String
    let titleText: String
    let priceText: String
    let style: Style
    
    init(year: UInt, title: String, price: Double, style: Style = .bold) {
        self.yearText = year != 0 ? "\(year)" : ""
        self.titleText = title
        self.priceText = Float(price).currency(fractionDigits: 0) ?? ""
        self.style = style
    }
    
    static var cellIdentifier: String {
        return String(describing: WinesMainCell.self)
    }
    
    func height(for width: CGFloat) -> CGFloat {
        return WinesMainCell.cellHeight(for: self, width: width)
    }
}
