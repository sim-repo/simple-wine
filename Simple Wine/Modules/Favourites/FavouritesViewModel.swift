import Foundation
import UIKit

typealias FavouriteCellViewModel = DetailedSingleViewModel

final class FavouritesViewModel: NSObject, FavouritesModuleInput {
    
    var favouriteWines: [ProductDetail] = []
    private var favouriteCellViewModels: [FavouriteCellViewModel] = []
    var didSelectWine: ((Int, String) -> Void)?
    var didDeleteAllTapped: (([ProductDetail]) -> Void)?
    var onDeleteItem: ((Int) -> Void)?
    var onFavouritesListChange: (() -> Void)?
    private(set) var selectedIndex: Int = NSNotFound
    
    func setFavouriteWines(wines: [ProductDetail]) {
        self.favouriteWines = wines
        favouriteCellViewModels = wines.map { FavouriteCellViewModel(wine: $0, canEdit: true) }
        onFavouritesListChange?()
    }
    
    func deleteAll() {
        didDeleteAllTapped?(favouriteWines)
    }
    
    func deleteItem(index: Int) {
        didDeleteAllTapped?([favouriteWines[index]])
        favouriteWines.remove(at: index)
    }
    
}

extension FavouritesViewModel: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favouriteWines.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var viewModel = favouriteCellViewModels[indexPath.row]
        viewModel.selected = (indexPath.row == selectedIndex)
        viewModel.didEditTapped = {
            self.deleteItem(index: indexPath.row)
        }
        return viewModel.cell(for: tableView)
    }
    
}
