import CoreData

class ProductDetail: NSManagedObject, Entity {
    static var entityName: String {
        return "ProductDetail"
    }
    
    @NSManaged public var bitrixId: Int
    @NSManaged public var article: String?
    @NSManaged public var name: String?
    @NSManaged public var image: String?
    @NSManaged public var year: Int
    @NSManaged public var volume: String?
    @NSManaged public var sugar: String?
    @NSManaged public var color: String?
    @NSManaged public var region: String?
    @NSManaged public var manufacturer: String?
    @NSManaged public var grapes: [String]?
    @NSManaged public var price: Double
    @NSManaged public var hallPrice: Double
    @NSManaged public var isFavourite: Bool
    @NSManaged public var productDescription: String?
    @NSManaged public var russianName: String?
    @NSManaged public var country: ProductCountry?
    @NSManaged var lastUpdate: Date
    
    func update(with properties: ProductDetailPlainModel, lastUpdate: Date = Date()) {
        self.bitrixId = properties.bitrix_id
        self.article = properties.article
        self.name = properties.name
        self.image = properties.image
        self.year = properties.year
        self.volume = "\(properties.volume)"
        self.sugar = properties.sugar_type
        self.color = properties.color
        self.region = properties.region
        self.manufacturer = properties.manufacturer
        self.grapes = properties.grapes
        self.price = properties.price ?? 0.0
        self.hallPrice = properties.hall_price ?? 0.0
        self.productDescription = properties.description
        self.russianName = properties.russian_name
        self.lastUpdate = lastUpdate
    }
}
