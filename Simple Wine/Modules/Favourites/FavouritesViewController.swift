//
//  FavouritesViewController.swift
//  Simple Wine
//
//  Created by Aynur Galiev on 16.03.2018.
//  Copyright © 2018 Aynur Galiev. All rights reserved.
//

import UIKit

final class FavouritesViewController: BaseViewController {
    
    var detailedWineModule = ModulesFactory.detailedWine()
    var detailedTapView = UIView()
    
    private struct Constants {
        static let scaleRatio: CGFloat = UIScreen.main.bounds.width / 1024
        static let detailWineScreenSize: CGSize = CGSize(width: 454, height: 652)
    }
    
    private var leftAnchorConstraint: NSLayoutConstraint?

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        return tableView
    }()
        
    var viewModel: FavouritesViewModel! {
        didSet { bind() }
    }
    
    private lazy var placeholders: [UIView] = {
        return [UIView(), UIView()]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Избранное"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Удалить все", style: .done, target: self, action: #selector(deleteAll))
        let redTextAttributes = [
            NSAttributedString.Key.font : AppFont.simpleMedium(ofSize: 15),
            NSAttributedString.Key.foregroundColor : AppTheme.selected,
        ]
        navigationItem.rightBarButtonItem?.setTitleTextAttributes(redTextAttributes, for: .normal)
        
        tableView.registerViewModel(FavouriteCellViewModel.self)
        view.addSubview(tableView)
        placeholders.forEach {
            $0.backgroundColor = AppTheme.background
            view.addSubview($0)
        }
        addDetailedWineViewControllerCollapsed()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tableView.frame = CGRect(x: 144.0, y: 106, width: view.width - 144 - 230, height: view.height - 106)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        showDetailedWineViewController(show: false, animated: false)
    }
    
    private func bind() {
        tableView.dataSource = viewModel
        viewModel.onDeleteItem = { [weak self] index in
            guard let sself = self else { return }
            sself.tableView.beginUpdates()
            sself.tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .middle)
            sself.tableView.endUpdates()
        }
        viewModel.onFavouritesListChange = { [weak self] in
            guard let sself = self else { return }
            sself.tableView.reloadData()
        }
    }
    
    @objc private func deleteAll() {
        viewModel.deleteAll()
        self.navigationController?.popViewController(animated: true)
    }
    
    private func didWineLike(wine: ProductDetail) {
        for i in 0..<viewModel.favouriteWines.count {
            var viewWine = viewModel.favouriteWines[i]
            if viewWine.bitrixId == wine.bitrixId {
                viewWine.isFavourite = wine.isFavourite
                viewModel.favouriteWines[i] = viewWine
                return
            }
        }
    }
    
    private func didDetailClose() {
        var wines = viewModel.favouriteWines
        for i in 0..<wines.count {
            let wine = wines[i]
            if !wine.isFavourite {
                viewModel.deleteItem(index: i)
                tableView.deleteRows(at: [IndexPath(row: i, section: 0)], with: .left)
                wines.remove(at: i)
                break
            }
        }
        if wines.isEmpty {
            navigationController?.popViewController(animated: true)
        }
        showDetailedWineViewController(show: false, animated: true)
    }
    
    private func addDetailedWineViewControllerCollapsed() {
        detailedTapView.frame = CGRect(x: 0.0, y: 0.0, width: view.width, height: view.height)
        view.addSubview(detailedTapView)
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        detailedTapView.addGestureRecognizer(tap)
        detailedTapView.isUserInteractionEnabled = true
        let detailedWineViewController = detailedWineModule.vc
        addChild(detailedWineViewController)
        detailedWineViewController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(detailedWineViewController.view)
        detailedWineViewController.didMove(toParent: self)
        detailedWineModule.module.didWineLike = didWineLike
        detailedWineModule.module.didClose = didDetailClose
        detailedWineModule.vc.view.widthAnchor.constraint(equalToConstant: Constants.detailWineScreenSize.width).isActive = true
        detailedWineModule.vc.view.heightAnchor.constraint(equalToConstant: Constants.detailWineScreenSize.height).isActive = true
        detailedWineModule.vc.view.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        leftAnchorConstraint = detailedWineModule.vc.view.leftAnchor.constraint(equalTo: view.leftAnchor, constant: -Constants.detailWineScreenSize.width)
        leftAnchorConstraint?.isActive = true
        detailedWineViewController.view.isHidden = true
        detailedTapView.isHidden = true
    }
    
    private func showDetailedWineViewController(show: Bool, animated: Bool = true) {
        let animation = {
            self.leftAnchorConstraint?.constant = show ? 300 : -Constants.detailWineScreenSize.width
            if show {
                self.detailedWineModule.vc.view.applyShadow()
                self.detailedWineModule.vc.view.isHidden = false
                self.detailedTapView.isHidden = false
            } else {
                self.detailedTapView.isHidden = true
            }
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }
        let completion = { (finished: Bool) in
            if !show {
                self.detailedWineModule.vc.view.isHidden = true
            }
        }
        if animated {
            UIView.animate(withDuration: 0.25, animations: animation, completion: completion)
        } else {
            animation()
            completion(true)
        }
    }
    
    @objc private func handleTap(_ sender: UITapGestureRecognizer) {
        didDetailClose()
    }
    
}

extension FavouritesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        detailedWineModule.module.setBitrixId(bitrix_id: viewModel.favouriteWines[indexPath.row].bitrixId)
        showDetailedWineViewController(show: true, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let action = UITableViewRowAction(style: .normal, title: "Удалить") { (action, indexPath) in
            if self.viewModel.favouriteWines.count == 1 {
                self.navigationController?.popViewController(animated: true)
            }
            self.viewModel.deleteItem(index: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
        }
        action.backgroundColor = AppTheme.error
        return [action]
    }
    
//    @available(iOS 11.0, *)
//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        let action = UIContextualAction(style: .normal, title: nil, handler: { (action,view,completionHandler ) in
//            if self.viewModel.favouriteWines.count == 1 {
//                self.navigationController?.popViewController(animated: true)
//            }
//            self.viewModel.deleteItem(index: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .left)
//            completionHandler(true)
//        })
//        action.image = UIImage(named: "RedCrossButton")
//        action.backgroundColor = AppColor.simpleBackground
//        action.backgroundColor = UIColor(patternImage: UIImage(named: "RedCrossButton")!)
//        let confrigation = UISwipeActionsConfiguration(actions: [action])
//        return confrigation
//    }
    
}
