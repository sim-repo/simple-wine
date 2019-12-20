import CoreData

class Product: NSManagedObject {
    static var entityName: String {
        return "Product"
    }
    
    @NSManaged var key: String
    @NSManaged var bitrixId: Int
    @NSManaged var deeplink: String?
    @NSManaged var name: String?
    @NSManaged var manufacturer: String?
    @NSManaged var price: Double
    @NSManaged var hallPrice: Double
    @NSManaged var year: UInt
    @NSManaged var volume: Double
    @NSManaged var region: String?
    @NSManaged var sugar: String?
    @NSManaged var color: String?
    @NSManaged var country: ProductCountry?
    @NSManaged var order: Int
    @NSManaged var lastUpdate: Date
    
    @NSManaged public var category: Category?
    
    func update(with properties: ProductPlainModel, lastUpdate: Date = Date()) {
        self.bitrixId = properties.bitrix_id
        self.deeplink = properties.deeplink
        self.name = properties.name
        self.manufacturer = properties.manufacturer
        self.price = properties.price ?? 0.0
        self.hallPrice = properties.hall_price ?? 0.0
        self.year = properties.year ?? 0
        self.volume = properties.volume ?? 0.0
        self.region = properties.region
        self.sugar = properties.sugar
        self.color = properties.color
        self.lastUpdate = lastUpdate
    }
}

