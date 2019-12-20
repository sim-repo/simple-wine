import Foundation
import CoreData

class ProductDataStorage: DataStorage {

    //MARK: - Properties
    
    private(set) var context: NSManagedObjectContext!
    
    
    //MARK: - Initialization
    
    init(context: NSManagedObjectContext = CoreDataStack.shared.mainQueueContext) {
        self.context = context
    }
    
    
    //MARK: - Data Storage
    
    func insertNewObject(_ object: Decodable) -> NSManagedObject? {
        guard let productModel = object as? ProductPlainModel else {
            SWLog(error: SWError.unsupportedPlainModel)
            return nil
        }
        
        guard let product = NSEntityDescription.insertNewObject(forEntityName: Product.entityName, into: self.context) as? Product else {
            return nil
        }
        
        product.update(with: productModel)
        
        // Create country object if needed
        if let countryModel = productModel.country {
            let country = NSEntityDescription.insertNewObject(forEntityName: ProductCountry.entityName, into: self.context) as? ProductCountry
            country?.update(with: countryModel)
    
            product.country = country
        }
        
        return product
    }
    
    func delete(_ object: NSManagedObject) {
        self.context.delete(object)
    }
    
    func isEmpty() -> Bool {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Product.entityName)
        fetchRequest.fetchLimit = 1
        
        let result = try! self.context.fetch(fetchRequest)
        
        return result.isEmpty
    }
    
    
    //MARK: - Public methods
    
    func searchProducts(searchString: String) -> [Product] {
        guard searchString.count > 0 else { return [] }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Product.entityName)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]

        // Configure predicate
        let countryNamePredicate = NSPredicate(format: "country.name contains[c] %@", searchString)
        let regionPredicate = NSPredicate(format: "region contains[c] %@", searchString)
        let colorPredicate = NSPredicate(format: "color contains[c] %@", searchString)
        let namePredicate = NSPredicate(format: "name contains[c] %@", searchString)
        let sugarPredicate = NSPredicate(format: "sugar contains[c] %@", searchString)
        let yearPredicate = NSPredicate(format: "year contains[c] %@", searchString)
        let pricePredicate = NSPredicate(format: "price contains[c] %@", searchString)
        let volumePredicate = NSPredicate(format: "volume contains[c] %@", searchString)
        let orCompoundPredicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.or, subpredicates: [countryNamePredicate, regionPredicate, colorPredicate, namePredicate, sugarPredicate, yearPredicate, pricePredicate, volumePredicate])
        fetchRequest.predicate = orCompoundPredicate
        
        
        let products = try? self.context.fetch(fetchRequest) as! [Product]
        
        return products ?? []
    }
    
    func fetchProducts(for category: Category) -> [NSManagedObject] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Product.entityName)
        fetchRequest.predicate = NSPredicate(format: "category == %@", category)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "order", ascending: true)]
        
        let products = try? self.context.fetch(fetchRequest) as! [Product]
        
        return products ?? []
    }
    
    func clearAll() {
        // Clear data
        let productFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Product")
        let productDeleteRequest = NSBatchDeleteRequest(fetchRequest: productFetchRequest)
        
        let countryFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ProductCountry")
        let countryDeleteRequest = NSBatchDeleteRequest(fetchRequest: countryFetchRequest)
        
        let context = CoreDataStack.shared.mainQueueContext
        do {
            try context.execute(productDeleteRequest)
            try context.execute(countryDeleteRequest)
            
            try? context.save()
        } catch let error as NSError {
            SWLog(error: error)
        }
        
    }
    
    func clear(before: Date) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Product.entityName)
        fetchRequest.predicate = NSPredicate(format: "lastUpdate < %@", before as CVarArg)
        
        if let result = try? self.context.fetch(fetchRequest) {
            result.forEach { self.context.delete($0 as! NSManagedObject) }
            try? self.context.save()
        }
    }
}
