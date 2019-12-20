import Foundation
import UIKit

final class ModulesFactory {
    
    class func detailedWine() -> (vc: UIViewController, module: DetailWineModuleInput) {
        let viewModel = DetailWineViewModel()
        let vc = DetailWineViewController(viewModel: viewModel)
        return (vc, viewModel)
    }
    
    class func winesList() -> (vc: UIViewController, module: WinesModuleInput) {
        let viewModel = WinesViewModel()
        let vc: WinesViewController = WinesViewController()
        vc.viewModel = viewModel
        return (vc, viewModel)
    }
    
    class func wineMap() -> (vc: UIViewController, module: WineMapModuleInput) {
        let viewModel = WineMapViewModel()
        //let vc: WineMapViewController = WineMapViewController.fromStoryboard()
        let vc: WineMapViewController2 = WineMapViewController2.fromStoryboard()
        vc.viewModel = viewModel
        return (vc, viewModel)
    }
    
    class func wineTypes(categoryIndex: UInt) -> (vc: UIViewController, module: WineTypesModuleInput) {
        let viewModel = WineTypesViewModel(categoryIndex: categoryIndex)
        let vc = WineTypesViewController()
        vc.viewModel = viewModel
        return (vc, viewModel)
    }
    
    class func wineMenu(categoryIndex: UInt) -> (view: UIView, module: WineMenuInput) {
        let viewModel = WineMenuModel(categoryIndex: categoryIndex)
        let v:WineMenuView = WineMenuView.fromXib()
        v.viewModel = viewModel
        return (v, viewModel)
    }
    
    class func categories(cardType: WineMapMode) -> (vc: UIViewController, module: CategoriesModuleInput) {
        let viewModel = CategoriesViewModel(cardType: cardType)
        let vc = CategoriesViewController()
        vc.viewModel = viewModel
        return (vc, viewModel)
    }
    
    class func systemDevice() -> SystemDeviceModule {
        let viewModel = SystemDeviceModule()
        return viewModel
    }
    
    class func whiteLabelList() -> (vc: UIViewController, module: WhiteLabelListModuleInput) {
        let viewModel = WhiteLabelListViewModel()
        let vc: WhiteLabelListViewController = WhiteLabelListViewController.fromStoryboard()
        vc.viewModel = viewModel
        return (vc, viewModel)
    }
    
    class func signIn() -> (vc: UIViewController, module: SignInModuleInput) {
        let viewModel = SignInViewModel()
        let vc: SignInViewController = SignInViewController.fromStoryboard()
        vc.viewModel = viewModel
        return (vc, viewModel)
    }
    
    class func menuCover() -> (vc: UIViewController, module: MenuCoverModuleInput) {
        let viewModel = MenuCoverViewModel()
        let vc: MenuCoverViewController = MenuCoverViewController.fromStoryboard()
        vc.viewModel = viewModel
        return (vc, viewModel)
    }
    
    class func mapMode() -> UIViewController {
        let vc: MapModeViewController = MapModeViewController.fromStoryboard()
        return vc
    }
    
    class func favourites() -> (vc: UIViewController, module: FavouritesModuleInput) {
        let viewModel = FavouritesViewModel()
        let vc = FavouritesViewController()
        vc.viewModel = viewModel
        return (vc, viewModel)
    }
    
}
