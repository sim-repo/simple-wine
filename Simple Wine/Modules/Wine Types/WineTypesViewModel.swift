import Foundation
import UIKit

typealias WineTypeCellViewModel = SingleLineViewModel

final class WineTypesViewModel: NSObject, WineTypesModuleInput {
 
    var didFirstSelected: (() -> Void)?
    var didCategorySelect: ((Category, UInt) -> Void)?
    var didCategoriesLoad: (([Category]) -> Void)?
    var didCategoriesLoadFail: ((SWError) -> Void)?
    var didResizeView: (() -> Void)?
    private var categoryIndex: UInt = 0
    var categories: [Category] = []
    var heightForView: CGFloat
    
    init(categoryIndex: UInt) {
        self.categoryIndex = categoryIndex
        self.heightForView = 0.0
    }
    
    func selectFirst() {
        didFirstSelected?()
    }
    
    func selectCategory(for categoryName: String) {
        for category in categories {
            if categoryName == category.name {
                didCategorySelect?(category, categoryIndex)
            }
        }
    }
    
    func loadWineTypes(for category:Category) {
        let dataStorage = CategoryDataStorage(cardType: .classic)
        self.categories = dataStorage.fetchCategories(parentCategory: category)
        
        for category in self.categories {
            let categoryName = category.name
            if categoryName.lowercased().contains("все с") || categoryName.lowercased().contains("все р") {
                let sortedCategories = categories.sorted {$0.count > $1.count}
                self.categories = sortedCategories
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
    
}

extension WineTypesViewModel: UITableViewDataSource {
    
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
