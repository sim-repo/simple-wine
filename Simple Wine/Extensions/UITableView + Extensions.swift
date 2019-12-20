import Foundation
import UIKit

extension UITableView {
    
    func registerViewModel< T: CellViewModel>(_ type: T.Type) {
        self.register(T.nib, forCellReuseIdentifier: T.cellIdentifier)
    }
}

extension UICollectionView {
    
    func registerViewModel< T: CollectionCellViewModel>(_ type: T.Type) {
        self.register(T.nib, forCellWithReuseIdentifier: T.cellIdentifier)
    }
    
}
