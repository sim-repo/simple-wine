import Foundation
import CoreData

class CategoryDataStorage: DataStorage {
    //MARK: - Properties
    
    private(set) var cardType: WineMapMode!
    private(set) var context: NSManagedObjectContext!
    
    
    //MARK: - Initialization
    
    required init(cardType: WineMapMode, context: NSManagedObjectContext = CoreDataStack.shared.mainQueueContext) {
        self.cardType = cardType
        self.context = context
    }
    
    
    //MARK: - Data Storage
    
    func insertNewObject(_ object: Decodable) -> NSManagedObject? {
        guard let categoryModel = object as? CategoryPlainModel else {
            SWLog(error: SWError.unsupportedPlainModel)
            return nil
        }
        
        guard let category = NSEntityDescription.insertNewObject(forEntityName: Category.entityName, into: self.context) as? Category else {
            return nil
        }
        category.update(with: categoryModel)
        category.cardType = self.cardType.rawValue
        
        return category
    }
    
    func delete(_ object: NSManagedObject) {
        self.context.delete(object)
    }
    
    func object(_ objectId: NSManagedObjectID) -> NSManagedObject? {
        return try? self.context.existingObject(with: objectId)
    }
    
    func isEmpty() -> Bool {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Category.entityName)
        fetchRequest.fetchLimit = 1
        
        let result = try! self.context.fetch(fetchRequest)

        return result.isEmpty
    }
    
    func clearAll() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Category.entityName)
        fetchRequest.predicate = NSPredicate(format: "cardType == %d", self.cardType.rawValue)
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try self.context.execute(deleteRequest)
            try? self.context.save()
            
        } catch let error as NSError {
            SWLog(error: error)
        }
    }
    
    func clear(before: Date) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Category.entityName)
        fetchRequest.predicate = NSPredicate(format: "lastUpdate < %@", before as CVarArg)
        
        if let result = try? self.context.fetch(fetchRequest) {
            result.forEach { self.context.delete($0 as! NSManagedObject) }
            try? self.context.save()
        }
    }
    
    //MARK: - Public methods
    
    func fetchParentCategories() -> [Category] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Category.entityName)
        
        fetchRequest.predicate = NSPredicate(format: "cardType == %d AND parentCategory == nil", self.cardType.rawValue)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "order", ascending: true)]
        
        let categories = try? self.context.fetch(fetchRequest) as! [Category]
        
        return categories ?? []
    }
    
    func fetchCategories(parentCategory: Category) -> [Category] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Category.entityName)
        fetchRequest.predicate = NSPredicate(format: "parentCategory == %@", parentCategory)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "order", ascending: true)]
        
        let categories = try? self.context.fetch(fetchRequest) as! [Category]
        
        return categories ?? []
    }
}
