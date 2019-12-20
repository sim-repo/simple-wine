import Foundation
import UIKit

protocol CellConfigurable {
    func configure(with viewModel: CellViewModel)
}

protocol CellViewModel {
    func cell(for tableView: UITableView) -> UITableViewCell & CellConfigurable
    func height(for width: CGFloat) -> CGFloat
    static var cellIdentifier: String { get }
}

extension CellViewModel {
    
    static var nib: UINib? {
        return UINib(nibName: cellIdentifier, bundle: nil)
    }
    
    func cell(for tableView: UITableView) -> UITableViewCell & CellConfigurable {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: type(of: self).cellIdentifier) as? UITableViewCell & CellConfigurable else {
            fatalError("No cell for \(type(of: self).cellIdentifier)")
        }
        cell.configure(with: self)
        return cell
    }
}

protocol CollectionCellConfigurable {
    func configure(with viewModel: CollectionCellViewModel)
}

protocol CollectionCellViewModel {
    func cell(for collectionView: UICollectionView) -> UICollectionViewCell & CollectionCellConfigurable
    func height(for width: CGFloat) -> CGFloat
    static var cellIdentifier: String { get }
}

extension CollectionCellViewModel {
    
    static var nib: UINib? {
        return UINib(nibName: cellIdentifier, bundle: nil)
    }
    
    func cell(for collectionView: UICollectionView) -> UICollectionViewCell & CollectionCellConfigurable {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: type(of: self).cellIdentifier, for: IndexPath(row: 0, section: 0)) as? UICollectionViewCell & CollectionCellConfigurable else {
            fatalError("No cell for \(type(of: self).cellIdentifier)")
        }
        cell.configure(with: self)
        return cell
    }
    
}
