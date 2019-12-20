import UIKit

enum WineMapMode: Int16 {
    case classic = 1, price
    
    var description : String {
        get {
            switch(self) {
            case .classic:
                return "classic"
            case .price:
                return "price"
            }
        }
    }
}

enum FilterScreenState {
    case full
    case collapsed
}

enum ScreenSelector: Hashable {
    case categories
    case wines
}

//let mainLineColor = UIColor(r: 180, g: 180, b: 177).cgColor

final class WineMapViewController: BaseViewController {
    
    private struct Constants {
        static let scaleRatio: CGFloat = UIScreen.main.bounds.width / 1024
        static let detailWineScreenSize: CGSize = CGSize(width: 454, height: 652)
    }
    
    // MARK: - Outlets
    @IBOutlet private weak var toolBar: WineToolbar!
    @IBOutlet private weak var containerView: UIView!
    
    var productTitles = [String]()
    
    var viewModel: WineMapViewModel! {
        didSet { bind() }
    }
    
    // MARK: - Instance Properties
    private lazy var wineTypeModules = [(vc: UIViewController, module: WineTypesModuleInput)]()
    private lazy var categoriesModule = ModulesFactory.categories(cardType: viewModel.wineMapMode == .classic ? .classic : .price) // Refactor me
    private lazy var winesModule = ModulesFactory.winesList()
    private lazy var detailedTapView = UIView()
    private lazy var detailedWineModule = ModulesFactory.detailedWine()
    private lazy var favoritesModule = ModulesFactory.favourites()
    private var leftAnchorConstraint: NSLayoutConstraint?
    
    private var selectors: [ScreenSelector: FilterScreenState] = [:]
    
    private func bind() {
        viewModel.didSelectedWinesChange = updateSelectCounter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateSelectCounter()
        configureMap(for: viewModel.wineMapMode)
        toolBar.searchClicked = handleSearchClicked
        
        categoriesModule.module.selectFirst()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        var wineTypeIndex = 0
        while wineTypeModules.count > wineTypeIndex {
            wineTypeModules[wineTypeIndex].module.selectFirst()
            wineTypeIndex += 1
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        view.bringSubviewToFront(categoriesModule.vc.view)
        
        for wineTypeModule in wineTypeModules {
            view.bringSubviewToFront(wineTypeModule.vc.view)
        }
        
        view.bringSubviewToFront(winesModule.vc.view)
        view.bringSubviewToFront(toolBar)
        view.bringSubviewToFront(detailedTapView)
        view.bringSubviewToFront(detailedWineModule.vc.view)
        view.bringSubviewToFront(favoritesModule.vc.view)
        
        let frame: CGRect = navigationController?.navigationBar.frame ?? CGRect(x: 0, y: 0, width: 0, height: 44)
        let top = frame.origin.y + frame.height
        toolBar.frame = CGRect(x: 10, y: top, width: UIScreen.main.bounds.width-35, height: 50)
        toolBar.addBorder(toSide: .top, withColor: AppTheme.line.cgColor, withThickness: 1)
        toolBar.addBorder(toSide: .bottom, withColor: AppTheme.line.cgColor, withThickness: 1)
        containerView.frame = CGRect(x: 0, y: toolBar.frame.maxY, width: 300, height: UIScreen.main.bounds.height - toolBar.frame.maxY)
        updateFrames()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateFrames()
    }
    
    private func updateFrames() {
        let frame: CGRect = navigationController?.navigationBar.frame ?? CGRect(x: 0, y: 0, width: 0, height: 44)
        let top = frame.origin.y + frame.height
        let maxCategories = 2
        let categoryWidth = toolBar.searchBar.frame.minX
        let subCategoryWidth: CGFloat = 250.0
        categoriesModule.vc.view.frame = CGRect(x: 0, y: 0, width: categoryWidth, height: toolBar.height)
        for i in 0..<wineTypeModules.count {
            let wineTypeModule = wineTypeModules[i]
            let wineTypeY = i == 1 ? wineTypeModules[i-1].vc.view.bottom : 8
            if i < maxCategories {
                var height = wineTypeModule.module.heightForView - 8
                if i == maxCategories - 1 {
                    height = containerView.height - 8
                    for j in 0..<maxCategories - 1 {
                        height -= wineTypeModules[j].module.heightForView
                    }
                }
                wineTypeModule.vc.view.frame = CGRect(x: 0, y: wineTypeY, width: subCategoryWidth, height: height)
            } else {
                let firstWineTypeModule = wineTypeModules.first!
                wineTypeModule.vc.view.frame = CGRect(x: firstWineTypeModule.vc.view.right - 55, y: wineTypeY, width: subCategoryWidth, height: /*wineTypeModule.module.heightForView - 8*/(containerView.height) / CGFloat(UInt(wineTypeModules.count / 2)) - 8)
            }
        }
        let winesX = wineTypeModules.count == 0 ? 0.0 : wineTypeModules.last!.vc.view.right - 40
        let winesWidth = selectors[.wines] == .collapsed ? 0.0 : view.width - winesX - 8
        var containerViewFrame = containerView.frame
        containerViewFrame.size.width = winesX
        containerView.frame = containerViewFrame
        winesModule.vc.view.frame = CGRect(x: winesX, y: toolBar.height + 8 + top, width: winesWidth, height: view.height - toolBar.frame.maxY)
    }
    
    private func updateSelectCounter() {
        let selectString = "Выбрано: \(viewModel.selectedWines.count)"
        if navigationItem.rightBarButtonItem == nil {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: selectString, style: .plain, target: self, action: #selector(selectDidTap))
            let redTextAttributes = [
                NSAttributedString.Key.font : AppFont.simpleMedium(ofSize: 15),
                NSAttributedString.Key.foregroundColor : AppTheme.selected,
            ]
            let grayTextAttributes = [
                NSAttributedString.Key.font : AppFont.simpleMedium(ofSize: 15),
                NSAttributedString.Key.foregroundColor : AppTheme.unselected,
            ]
            navigationItem.rightBarButtonItem?.setTitleTextAttributes(redTextAttributes, for: .normal)
            navigationItem.rightBarButtonItem?.setTitleTextAttributes(grayTextAttributes, for: .disabled)
        } else {
            navigationItem.rightBarButtonItem?.title = selectString
        }
        navigationItem.rightBarButtonItem?.isEnabled = viewModel.selectedWines.count > 0
    }
    
    @objc private func selectDidTap() {
        favoritesModule.module.setFavouriteWines(wines: viewModel?.selectedWines ?? [])
        navigationController?.pushViewController(favoritesModule.vc, animated: true)
    }
    
}

// MARK: - configuring child filter view contorllers
extension WineMapViewController {
    
    private func configureMap(for mode: WineMapMode) {
        addCategoriesViewController()
        addWinesViewControllerCollapsed()
        addDetailedWineViewControllerCollapsed()
        favoritesModule.module.didSelectWine = handleWineSelected
        favoritesModule.module.didDeleteAllTapped = handleDeleteSelectedFavorites
        selectors = [
            .categories: .full,
            .wines: .collapsed
        ]
        view.clipsToBounds = true
        if viewModel.wineMapMode == .classic {
            title = "Классическая винная карта"
        } else {
            title = "Винная карта по цене"
        }
        navigationController?.navigationBar.shadowImage = UIImage()

        view.layoutIfNeeded()
    }
    
    private func addCategoriesViewController() {
        let categoriesViewController = categoriesModule.vc
        addChild(categoriesViewController)
        categoriesViewController.view.translatesAutoresizingMaskIntoConstraints = false
        toolBar.addSubview(categoriesViewController.view)
        categoriesViewController.didMove(toParent: self)
        categoriesModule.module.didCategorySelect = handleCategorySelected
    }
    
    private func addWineTypesViewController() {
        var wineTypesModule = ModulesFactory.wineTypes(categoryIndex: UInt(wineTypeModules.count))
        wineTypeModules.append(wineTypesModule)
        let wineTypesViewController = wineTypesModule.vc
        addChild(wineTypesViewController)
        wineTypesViewController.view.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(wineTypesViewController.view)
        wineTypesViewController.didMove(toParent: self)
        wineTypesModule.module.didCategorySelect = handleWineTypeSelected
        wineTypesModule.module.didResizeView = handleDidResizeCategory
    }
    
    private func addWinesViewControllerCollapsed() {
        let winesViewController = winesModule.vc
        addChild(winesViewController)
        winesViewController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(winesViewController.view)
        
        winesViewController.view.addPieceOfShadow()
        winesViewController.view.hideShadow(isHidden: true)
        winesViewController.didMove(toParent: self)
        winesModule.module.didSelectWine = handleWineSelected
    }
    
    private func addDetailedWineViewControllerCollapsed() {
        detailedTapView.frame = CGRect(x: 0.0, y: 0.0, width: view.width, height: view.height)
        view.addSubview(detailedTapView)
        detailedTapView.isHidden = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        detailedTapView.addGestureRecognizer(tap)
        detailedTapView.isUserInteractionEnabled = true
        let detailedWineViewController = detailedWineModule.vc
        addChild(detailedWineViewController)
        detailedWineViewController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(detailedWineViewController.view)
        detailedWineViewController.didMove(toParent: self)
        detailedWineModule.module.didWineLike = viewModel.selectWine
        detailedWineModule.module.didClose = { [weak self] in
            guard let sself = self else { return }
            sself.showDetailedWineViewController(show: false)
        }
        detailedWineModule.vc.view.widthAnchor.constraint(equalToConstant: Constants.detailWineScreenSize.width).isActive = true
        detailedWineModule.vc.view.heightAnchor.constraint(equalToConstant: Constants.detailWineScreenSize.height).isActive = true
        detailedWineModule.vc.view.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        leftAnchorConstraint = detailedWineModule.vc.view.leftAnchor.constraint(equalTo: view.leftAnchor, constant: -Constants.detailWineScreenSize.width)
        leftAnchorConstraint?.isActive = true
    }
    
    private func showDetailedWineViewController(show: Bool, animated: Bool = true) {
        let animation = {
            self.leftAnchorConstraint?.constant = show ? 300 : -Constants.detailWineScreenSize.width
            if show {
                self.detailedWineModule.vc.view.applyShadow()
                self.categoriesModule.vc.view.alpha = 0.7
                for wineTypeModule in self.wineTypeModules {
                    wineTypeModule.vc.view.alpha = 0.7
                }
                self.winesModule.vc.view.alpha = 0.7
                self.detailedTapView.isHidden = false
            } else {
                self.categoriesModule.vc.view.alpha = 1.0
                for wineTypeModule in self.wineTypeModules {
                    wineTypeModule.vc.view.alpha = 1.0
                }
                self.winesModule.vc.view.alpha = 1.0
                self.detailedTapView.isHidden = true
            }
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }
        let completion = { (finished: Bool) in
            if !show {
                self.detailedWineModule.vc.view.applyShadow(shouldApply: false)
            }
        }
        if animated {
            UIView.animate(withDuration: 0.25, animations: animation, completion: completion)
        } else {
            animation()
            completion(true)
        }
    }
    
}

// MARK: - Handling filter item selected
extension WineMapViewController {
    
    @objc private func handleTap(_ sender: UITapGestureRecognizer) {
        showDetailedWineViewController(show: false, animated: true)
    }
    
    private func handleDidResizeCategory() {
        UIView.animate(withDuration: 0.3, animations: {
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        })
    }
    
    private func handleCategorySelected(_ category: Category) {
        
        while 0 <= wineTypeModules.count - 1 {
            let categoryView = wineTypeModules.last
            categoryView?.vc.view.removeFromSuperview()
            categoryView?.vc.removeFromParent()
            wineTypeModules.removeLast()
        }

        selectors[.wines] = .collapsed
        self.winesModule.vc.view.hideShadow(isHidden: true)
        addWineTypesViewController()
        wineTypeModules.last!.module.loadWineTypes(for: category)

    }
    
    private func handleWineTypeSelected(_ category:Category, _ controllerIndex: UInt) {
        let deeplink = category.deeplink
        
        var filters = [[String]]()
        let urlItems = deeplink.components(separatedBy: "?")
        if (urlItems.count > 1) {
            let queryItems = urlItems[1].components(separatedBy: "&")
            for queryItem in queryItems {
                filters.append(queryItem.components(separatedBy: "="))
            }
        }
        while controllerIndex < wineTypeModules.count - 1 {
            let categoryView = wineTypeModules.last
            categoryView?.vc.view.removeFromSuperview()
            categoryView?.vc.removeFromParent()
            wineTypeModules.removeLast()
        }
        while productTitles.count != wineTypeModules.count - 1 {
            productTitles.removeLast()
        }
        productTitles.append(category.name)
        if deeplink.contains("products") {
            var productTitle = ""
            for i in (0..<productTitles.count).reversed() {
                let lastTitle = productTitles[i].lowercased()
                if !lastTitle.contains("все") && !lastTitle.contains("до ") && !lastTitle.contains("от ") /* && !lastTitle.contains("vintage") && !lastTitle.contains("n/v brut") && !lastTitle.contains("n/v demisec") */{
                    productTitle = productTitles[i]
                    break
                }
            }
            winesModule.module.loadWines(for: category, filters: filters, title: productTitle)
            selectors[.wines] = .full
            self.winesModule.vc.view.hideShadow(isHidden: false)
        } else if deeplink.contains("categories") {
            selectors[.wines] = .collapsed
            self.winesModule.vc.view.hideShadow(isHidden: true)
            addWineTypesViewController()
        
            wineTypeModules.last!.module.loadWineTypes(for: category)
        }
        UIView.animate(withDuration: 0.3, animations: {
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        })
    }
    
    private func handleWineSelected(bitrix_id: Int, wine: String) {
        detailedWineModule.module.setBitrixId(bitrix_id: bitrix_id)
        showDetailedWineViewController(show: true)
    }
    
    private func handleDeleteSelectedFavorites(wines: [ProductDetail]) {
        viewModel.deleteSelectedFavorites(wines: wines)
    }
    
    private func handleSearchClicked(text: String?) {
        if let searchString = text {
            let dataStorage = ProductDataStorage()
            let wines = dataStorage.searchProducts(searchString: searchString)
            winesModule.module.loadSearchWines(wines: wines, searchString: searchString)
            selectors[.wines] = .full
            winesModule.vc.view.hideShadow(isHidden: false)
        } else {
            selectors[.wines] = .collapsed
            self.winesModule.vc.view.hideShadow(isHidden: true)
        }
    }    
}

struct FiltersMargin {
    //Magrins of filter pages for screen 1024 ppt width
    
    // classic mode
    static let classicCountriesExpanded: CGFloat = 222
    static let classicCountriesCollapsed: CGFloat = (1024-120)
    
    static let classicWineListExpanded: CGFloat = 444
    static let classicWineListCollapsed: CGFloat = (1024-60)
    
    // byPrice mode
    static let byPriceCountriesExpanded: CGFloat = 185
    static let byPriceCountriesCollapsed: CGFloat = (1024-120)
    
    static let byPriceRangesExpanded: CGFloat = 370
    static let byPriceRangesCollapsed: CGFloat = (1024-80)
    
    static let byPriceWineListExpanded: CGFloat = 555
    static let byPriceWineListCollapsed: CGFloat = (1024-40)
    
}
