//
//  CategoriesViewController.swift
//  Simple Wine
//
//  Created by Ivan Babich on 20/10/2018.
//  Copyright © 2018 Aynur Galiev. All rights reserved.
//

import UIKit

class CategoriesViewController: BaseViewController {
    
    var viewModel: CategoriesViewModel! {
        didSet { bind() }
    }
    
    private var isTouchFirst = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isTouchFirst = false
        
        viewModel.loadCategories()
        viewModel.didFirstSelect = touchFirst
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateData), name: .synchronizationDidFinish, object: nil)
    }
    
    @objc private func updateData() {
        // Easy fix to reload data after sync update without complete screen reload
        unbind()
        viewModel.loadCategories()
        bind()
    }
    
    private func bind() {
        viewModel.didCategoriesLoad = { [weak self] _ in
            guard let sself = self else { return }
            UI_THREAD {
                sself.reloadView()
                if sself.isTouchFirst {
                    sself.setFirst()
                }
            }
        }
        viewModel.didCategoriesLoadFail = { [weak self] error in
            guard let sself = self else { return }
            UI_THREAD {
                let alert = UIAlertController(error: error)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                sself.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    private func unbind() {
        viewModel.didCategoriesLoad = nil
        viewModel.didCategoriesLoadFail = nil
    }
    
    private func touchFirst() {
        isTouchFirst = true
    }
    
    private func setFirst() {
        for categoryButton in categoryButtons {
            categoryButton.setTitleColor(AppTheme.unselected, for: .normal)
            categoryButton.titleLabel?.font = AppFont.geometriaLight(ofSize: 16)
        }
        guard let categoryButton = categoryButtons.first else {
            return
        }
        if let categoryName = categoryButton.title(for: .normal) {
            categoryButton.setTitleColor(AppTheme.selected, for: .normal)
            categoryButton.titleLabel?.font = AppFont.geometriaMedium(ofSize: 16)
            viewModel.selectCategory(for: categoryName)
        }
    }
    
    @objc func touchCategory(_ sender: UIButton) {
        for categoryButton in categoryButtons {
            categoryButton.setTitleColor(AppTheme.unselected, for: .normal)
            categoryButton.titleLabel?.font = AppFont.geometriaLight(ofSize: 16)
        }
        if let categoryName = sender.title(for: .normal) {
            sender.setTitleColor(AppTheme.selected, for: .normal)
            sender.titleLabel?.font = AppFont.geometriaMedium(ofSize: 16)
            viewModel.selectCategory(for: categoryName)
        }
    }
    
    private var categoryButtons = [UIButton]()
    
    private func reloadView() {
        for subView in view.subviews {
            subView.removeFromSuperview()
        }
        for category in viewModel.categories {
            let categoryButton = UIButton()
            categoryButton.setTitle(category.name, for: .normal)
            categoryButton.titleLabel?.font = AppFont.geometriaLight(ofSize: 16)
            categoryButton.setTitleColor(AppTheme.unselected, for: .normal)
            categoryButton.addTarget(self, action: #selector(touchCategory(_:)), for: .touchUpInside)
            view.addSubview(categoryButton)
            categoryButtons.append(categoryButton)
        }
        let stackView = UIStackView(arrangedSubviews: view.subviews)
        stackView.axis = .horizontal
        stackView.distribution = .equalCentering
        stackView.alignment = .center
        stackView.spacing = 32
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        let viewsDictionary = ["stackView" : stackView]
        let stackViewHorizontal = NSLayoutConstraint.constraints(withVisualFormat:
            "H:|-35-[stackView]-8-|",
            options: NSLayoutConstraint.FormatOptions(rawValue: 0),
            metrics: nil,
            views: viewsDictionary)
        let stackViewVertical = NSLayoutConstraint.constraints(withVisualFormat:
            "V:|-15-[stackView]-15-|",
            options: NSLayoutConstraint.FormatOptions(rawValue:0),
            metrics: nil,
            views: viewsDictionary)
        view.addConstraints(stackViewHorizontal)
        view.addConstraints(stackViewVertical)
    }
    
}
