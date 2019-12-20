import CoreData

class Category: NSManagedObject, Entity {
    static var entityName: String {
        return "Category"
    }
    
    @NSManaged var key: String
    @NSManaged var categoryId: UInt
    @NSManaged var name: String
    @NSManaged var deeplink: String
    @NSManaged var count: UInt
    @NSManaged var order: Int
    @NSManaged var cardType: Int16
    @NSManaged var isRoot: Bool
    @NSManaged var lastUpdate: Date
    
    @NSManaged public var parentCategory: Category?
    @NSManaged public var childCategories: NSSet?
    
    @NSManaged public var products: NSSet?
    
    func update(with properties: CategoryPlainModel, lastUpdate: Date = Date()) {
        self.categoryId = properties.category_id
        self.name = properties.name ?? ""
        self.deeplink = properties.deeplink
        self.count = properties.count ?? 0
        self.lastUpdate = lastUpdate
    }
    
    var filters: [[String]] {
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
}

extension Category {
    
    @objc(addChildCategoriesObject:)
    @NSManaged public func addToChildCategories(_ value: Category)
    
    @objc(removeChildCategoriesObject:)
    @NSManaged public func removeFromChildCategories(_ value: Category)
    
    @objc(addChildCategories:)
    @NSManaged public func addToChildCategories(_ values: NSSet)
    
    @objc(removeChildCategories:)
    @NSManaged public func removeFromChildCategories(_ values: NSSet)
    
}

