import Foundation
import CoreData

protocol DataStorage: class {
    func insertNewObject(_ object: Decodable) -> NSManagedObject?
    func delete(_ object: NSManagedObject)
    func isEmpty() -> Bool
    func object(_ objectId: NSManagedObjectID) -> NSManagedObject?
    
    func clearAll()
    func clear(before: Date)
}

extension DataStorage {
    
    func object(_ objectId: NSManagedObjectID) -> NSManagedObject? { return nil }
}
