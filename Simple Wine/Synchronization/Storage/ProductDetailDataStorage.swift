import Foundation
import CoreData

class ProductDetailDataStorage: DataStorage {
    //MARK: - Properties
    
    private(set) var context: NSManagedObjectContext!
    
    
    //MARK: - Initialization
    
    required init(context: NSManagedObjectContext = CoreDataStack.shared.mainQueueContext) {
        self.context = context
    }
    
    
    //MARK: - Data Storage
    
    func insertNewObject(_ object: Decodable) -> NSManagedObject? {
        guard let plainModel = object as? ProductDetailPlainModel else {
            SWLog(error: SWError.unsupportedPlainModel)
            return nil
        }
        
        guard let productDetail = NSEntityDescription.insertNewObject(forEntityName: ProductDetail.entityName, into: self.context) as? ProductDetail else {
            return nil
        }
        productDetail.update(with: plainModel)
        
        // Create country object if needed
        if let countryModel = plainModel.country {
            let country = NSEntityDescription.insertNewObject(forEntityName: ProductCountry.entityName, into: self.context) as? ProductCountry
            country?.update(with: countryModel)
            
            productDetail.country = country
        }
        
        return productDetail
    }
    
    func delete(_ object: NSManagedObject) {
        self.context.delete(object)
    }
    
    func isEmpty() -> Bool {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: ProductDetail.entityName)
        fetchRequest.fetchLimit = 1
        
        let result = try! self.context.fetch(fetchRequest)
        
        return result.isEmpty
    }
    
    func clearAll() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: ProductDetail.entityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try self.context.execute(deleteRequest)
            try? self.context.save()
            
        } catch let error as NSError {
            SWLog(error: error)
        }
    }
    
    func clear(before: Date) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: ProductDetail.entityName)
        fetchRequest.predicate = NSPredicate(format: "lastUpdate < %@", before as CVarArg)
        
        if let result = try? self.context.fetch(fetchRequest) {
            result.forEach { self.context.delete($0 as! NSManagedObject) }
            try? self.context.save()
        }
    }
    
    
    //MARK: - Public
    
    func fetchProductDetails(for bitrixId:String) -> ProductDetail? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: ProductDetail.entityName)
        fetchRequest.predicate = NSPredicate(format: "bitrixId == %@", bitrixId)
        
        let result = try? self.context.fetch(fetchRequest) as! [ProductDetail]
        
        return result?.first
    }
    
    func fetchFavourites() -> [ProductDetail] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: ProductDetail.entityName)
        fetchRequest.predicate = NSPredicate(format: "isFavourite == 1")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: false)]
        
        let favourites = try? self.context.fetch(fetchRequest) as! [ProductDetail]
        
        return favourites ?? []
    }
    
    func setFavourite(_ isFavourite:Bool, for productDetails:[ProductDetail]) {
        productDetails.forEach { $0.isFavourite = isFavourite }
        
        try? self.context.save()
    }
    
}
