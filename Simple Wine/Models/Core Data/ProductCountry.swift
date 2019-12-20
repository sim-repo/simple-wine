import CoreData

class ProductCountry: NSManagedObject, Entity {
    static var entityName: String {
        return "ProductCountry"
    }
    
    @NSManaged public var name: String
    @NSManaged public var flag: String
    @NSManaged public var regions: [String]
    @NSManaged var lastUpdate: Date
    
    @NSManaged public var products: NSSet
    
    func update(with properties: CountryPlainModel, lastUpdate: Date = Date()) {
        self.name = properties.name
        self.flag = properties.flag ?? ""
        self.regions = properties.regions
        self.lastUpdate = lastUpdate
    }
}

