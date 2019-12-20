import Foundation
import UIKit

final class CategoriesViewModel: NSObject, CategoriesModuleInput {
    
    var didFirstSelect: (() -> Void)?
    var didCategorySelect: ((Category) -> Void)?
    var didCategoriesLoad: (([Category]) -> Void)?
    var didCategoriesLoadFail: ((SWError) -> Void)?
    
    var cardType: WineMapMode
    var categories: [Category] = []
    
    init(cardType: WineMapMode) {
        self.cardType = cardType
    }
    
    func selectFirst() {
        didFirstSelect?()
    }
    
    func selectCategory(for categoryName: String) {
        for category in categories {
            if categoryName == category.name {
                didCategorySelect?(category)
            }
        }
    }
    
    func loadCategories() {
        let dataStorage = CategoryDataStorage(cardType: cardType)
        self.categories = dataStorage.fetchParentCategories()
        didCategoriesLoad?(categories)
    }
    
}
