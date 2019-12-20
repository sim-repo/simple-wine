import Foundation

protocol FavouritesModuleInput {
    var didSelectWine: ((Int, String) -> Void)? { get set }
    func setFavouriteWines(wines: [ProductDetail])
    var didDeleteAllTapped: (([ProductDetail]) -> Void)? { get set }
}
