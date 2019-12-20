//
//  WineMenuModel.swift
//  Simple Wine
//
//  Created by Dmitry Laenko on 04/10/2019.
//  Copyright © 2019 Aynur Galiev. All rights reserved.
//

import UIKit

class WineMenuModel: NSObject, WineMenuInput {

    var heightForView: CGFloat
    var categories: [Category] = []
    var didCategorySelect: ((Category, UInt) -> Void)?
    var didCategoriesLoad: (([Category]) -> Void)?
    
    var didFirstSelected: (() -> Void)?
    
    private var categoryIndex: UInt = 0
    
    init(categoryIndex: UInt) {
        heightForView = 0
        super.init()
        self.categoryIndex = categoryIndex
    }
    
    func loadWineMenu(for category:Category) {
        
        let dataStorage = CategoryDataStorage(cardType: .classic)
        categories = dataStorage.fetchCategories(parentCategory: category)
        heightForView = CGFloat(categories.count * 40)
        for category in categories {
            let categoryName = category.name
            if categoryName.lowercased().contains("все с") || categoryName.lowercased().contains("все р") {
                let sortedCategories = categories.sorted {$0.count > $1.count}
                categories = sortedCategories
                didFirstSelected?()
                break
            } else if categoryName.lowercased().contains("до ") {
                didFirstSelected?()
                break
            } else {
                didFirstSelected?()
                break
            }
        }
        didCategoriesLoad?(categories)
    }
    
    func selectFirst() {
        didFirstSelected?()
    }
    
    func select(indexPath: IndexPath) {
        didCategorySelect?(categories[indexPath.row], categoryIndex)
    }
}

extension WineMenuModel: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var isLastCell = false
        if indexPath.row == categories.count - 1 {
            isLastCell = true
        }
        let viewModel = SingleLineViewModel(text: categories[indexPath.row].name, itemsCount: categories[indexPath.row].count, isLastCell: isLastCell)
        let cell = viewModel.cell(for: tableView)
        return cell
    }
    
}
