import Foundation
import UIKit

struct DetailedSingleViewModel: CellViewModel {
 
    typealias CellClass = DetailedSingleLineCell
    
    private(set) var titleText: String = ""
    private(set) var priceText: String = ""
    private(set) var canEdit: Bool = false
    var selected: Bool = false
    var didEditTapped: (() -> Void)?
    
    init(wine: ProductDetail, canEdit: Bool = false, selected: Bool = false) {
        if wine.year > 0 {
            self.titleText = "\(wine.year) г.  \(wine.name ?? "")"
        } else {
            self.titleText = wine.name ?? ""
        }
        if let region = wine.region {
            self.titleText += ", \(region)"
        }
        let price = Float(wine.hallPrice)
        self.priceText = price.currency(fractionDigits: 0) ?? ""
        self.canEdit = canEdit
        self.selected = selected
    }
    
    init() {}
    
    static var empty: DetailedSingleViewModel {
        return DetailedSingleViewModel()
    }
    
    static var cellIdentifier: String {
        return String(describing: DetailedSingleLineCell.self)
    }
    
    func configure(cell: UITableViewCell) {
        guard let cell = cell as? DetailedSingleLineCell else { return }
        cell.configure(with: self)
    }
    
    func height(for width: CGFloat) -> CGFloat {
        return DetailedSingleLineCell.cellHeight(for: self, width: width)
    }
}
