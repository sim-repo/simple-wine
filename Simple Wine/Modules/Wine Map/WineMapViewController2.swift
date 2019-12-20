//
//  WineMapViewController2.swift
//  Simple Wine
//
//  Created by Dmitry Laenko on 03/10/2019.
//  Copyright © 2019 Aynur Galiev. All rights reserved.
//

import UIKit

class WineMapViewController2: BaseViewController {

    @IBOutlet private weak var categoriesCollection: UICollectionView!
    @IBOutlet private weak var horizontalStack: UIStackView!
    @IBOutlet private weak var containerWines: UIView!
    
    var productTitles = [String]()
    
    var viewModel: WineMapViewModel! {
        didSet { bind() }
    }
    
    private lazy var categoryModel = CategoriesViewModel(cardType: viewModel.wineMapMode)
    private lazy var wineMenues = [(view: UIView, module: WineMenuInput)]()
    private lazy var winesListModel = WinesListModel()
    
    private lazy var detailedTapView = UIView()
    private lazy var detailedWineModule = ModulesFactory.detailedWine()
    private lazy var favoritesModule = ModulesFactory.favourites()
    private var leftAnchorConstraint: NSLayoutConstraint?
    
    private struct Constants {
        static let scaleRatio: CGFloat = UIScreen.main.bounds.width / 1024
        static let detailWineScreenSize: CGSize = CGSize(width: 754, height: 600)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoriesCollection.register(CollectionViewCell.nib, forCellWithReuseIdentifier: CollectionViewCell.identifier)
        configureMap(for: viewModel.wineMapMode)
        updateData()
        updateSelectCounter()
        NotificationCenter.default.addObserver(self, selector: #selector(updateData), name: .synchronizationDidFinish, object: nil)
        
        containerWines.addPieceOfShadow()
        containerWines.hideShadow(isHidden: true)
        containerWines.backgroundColor = AppTheme.background
    }
    
    private var isFirst = true
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? WinesListViewController {
            winesListModel.didSelectWine = handleWineSelected
            vc.viewModel = winesListModel
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        wineMenues.forEach { $0.module.selectFirst() }
    }
}

extension WineMapViewController2: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryModel.categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath) as! CollectionViewCell
        cell.caption = categoryModel.categories[indexPath.row].name
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: CollectionViewCell.width(categoryModel.categories[indexPath.row].name), height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        select(category: categoryModel.categories[indexPath.row])
    }
}

extension WineMapViewController2: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        handleSearchClicked(text: searchBar.text)
    }
}

private extension WineMapViewController2 {
    
    func bind() {
        viewModel.didSelectedWinesChange = updateSelectCounter
    }
    
    func configureMap(for mode: WineMapMode) {
        addDetailedWineViewControllerCollapsed()
        favoritesModule.module.didSelectWine = handleWineSelected
        favoritesModule.module.didDeleteAllTapped = handleDeleteSelectedFavorites
        view.clipsToBounds = true
        if viewModel.wineMapMode == .classic {
            title = "Классическая винная карта"
        } else {
            title = "Винная карта по цене"
        }
        navigationController?.navigationBar.shadowImage = UIImage()

        view.layoutIfNeeded()
   }
    
    @objc func updateData(){
        categoryModel.loadCategories()
        categoriesCollection.reloadData()
        if categoryModel.categories.count > 0 && isFirst {
            isFirst = false
            categoriesCollection.selectItem(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: UICollectionView.ScrollPosition.left)
            select(category: categoryModel.categories[0])
        }
    }
    
    func select(category: Category) {
        while horizontalStack.arrangedSubviews.count > 0 {
            horizontalStack.arrangedSubviews.last?.removeFromSuperview()
        }
        wineMenues.removeAll()
        winesListModel.clearWines()
        
        let deeplink = category.deeplink
        if deeplink.contains("products") {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[view(1)]", metrics: nil, views: ["view" : view]))
            horizontalStack.addArrangedSubview(view)
            productTitles.removeAll()
            productTitles.append(category.name)
            winesListModel.loadWines(for: category, filters: category.filters, title: category.name)
            containerWines.hideShadow(isHidden: false)
        } else if deeplink.contains("categories") {
            addMenu()
            containerWines.hideShadow(isHidden: true)
            wineMenues.last!.module.loadWineMenu(for: category)
        }
    }
    
    func addMenu(){
        
        var wineMenue = ModulesFactory.wineMenu(categoryIndex: UInt(wineMenues.count))
        wineMenues.append(wineMenue)
        addUIMenu()
        
        wineMenue.module.didCategorySelect = handleWineMenuSelected
    }
    
    func addUIMenu(){
        guard let view = wineMenues.last?.view else { return }
        if (wineMenues.count % 2) == 1 {
            let vs = UIStackView(arrangedSubviews: [view])
            vs.axis = .vertical
            vs.translatesAutoresizingMaskIntoConstraints = false
            vs.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[view(210)]", metrics: nil, views: ["view" : vs]))
            horizontalStack.addArrangedSubview(vs)
        } else {
            guard let stack = horizontalStack.arrangedSubviews.last as? UIStackView else { return }
            stack.addArrangedSubview(view)
                        
            let h = horizontalStack.frame.height - wineMenues[wineMenues.count-2].module.heightForView
            view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[view(height)]", metrics: ["height" : h], views: ["view" : view]))
        }
        
    }
    
    func removeUIMenu(up index: UInt){
        while wineMenues.count > index + 1 {
            wineMenues.last?.view.removeFromSuperview()
            if (wineMenues.count % 2) == 1 {
                horizontalStack.arrangedSubviews.last?.removeFromSuperview()
            }
            wineMenues.removeLast()
        }
    }
    
    private func handleWineMenuSelected(_ category:Category, _ controllerIndex: UInt) {
        
        
        func parse(_ deeplink: String) -> [[String]] {
            var filters = [[String]]()
            let urlItems = deeplink.components(separatedBy: "?")
            if (urlItems.count > 1) {
                let queryItems = urlItems[1].components(separatedBy: "&")
                for queryItem in queryItems {
                    filters.append(queryItem.components(separatedBy: "="))
                }
            }
            return filters
        }
        
        let deeplink = category.deeplink
        let filters = parse(deeplink)
        removeUIMenu(up: controllerIndex)
        while productTitles.count != wineMenues.count - 1 { productTitles.removeLast() }
        productTitles.append(category.name)
        if deeplink.contains("products") {
            var productTitle = ""
            for i in (0..<productTitles.count).reversed() {
                let lastTitle = productTitles[i].lowercased()
                if !lastTitle.contains("все") && !lastTitle.contains("до ") && !lastTitle.contains("от "){
                    productTitle = productTitles[i]
                    break
                }
            }
            winesListModel.loadWines(for: category, filters: filters, title: productTitle)
            containerWines.hideShadow(isHidden: false)
            
        } else if deeplink.contains("categories") {
            addMenu()
            containerWines.hideShadow(isHidden: true)
            wineMenues.last!.module.loadWineMenu(for: category)
        }
        
        
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
    
    @objc func selectDidTap() {
        favoritesModule.module.setFavouriteWines(wines: viewModel?.selectedWines ?? [])
        navigationController?.pushViewController(favoritesModule.vc, animated: true)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        showDetailedWineViewController(show: false, animated: true)
    }
    
    func handleWineSelected(bitrix_id: Int, wine: String) {
        detailedWineModule.module.setBitrixId(bitrix_id: bitrix_id)
        showDetailedWineViewController(show: true)
    }
    
    func handleDeleteSelectedFavorites(wines: [ProductDetail]) {
        viewModel.deleteSelectedFavorites(wines: wines)
    }
    
    func handleSearchClicked(text: String?) {
        if let searchString = text {
            let dataStorage = ProductDataStorage()
            let wines = dataStorage.searchProducts(searchString: searchString)
            winesListModel.loadSearchWines(wines: wines, searchString: searchString)
            containerWines.hideShadow(isHidden: false)
        } else {
            containerWines.hideShadow(isHidden: true)
        }
    }
    
    func addDetailedWineViewControllerCollapsed() {
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
        detailedWineModule.vc.view.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: (Constants.detailWineScreenSize.height - UIScreen.main.bounds.height)/2).isActive = true
        leftAnchorConstraint = detailedWineModule.vc.view.leftAnchor.constraint(equalTo: view.leftAnchor, constant: -Constants.detailWineScreenSize.width)
        leftAnchorConstraint?.isActive = true
    }
        
    func showDetailedWineViewController(show: Bool, animated: Bool = true) {
        let animation = {
            self.leftAnchorConstraint?.constant = show ? (UIScreen.main.bounds.width - Constants.detailWineScreenSize.width)/2 : -Constants.detailWineScreenSize.width
            if show {
                self.detailedWineModule.vc.view.applyShadow()
                self.categoriesCollection.superview?.alpha = 0.7
                for menu in self.wineMenues {
                    menu.view.alpha = 0.7
                }
                self.containerWines.alpha = 0.7
                self.detailedTapView.isHidden = false
            } else {
                self.categoriesCollection.superview?.alpha = 1.0
                for menu in self.wineMenues {
                    menu.view.alpha = 1.0
                }
                self.containerWines.alpha = 1.0
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
