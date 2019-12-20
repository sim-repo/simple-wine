import Foundation

protocol Synchronizer {
    var isSyncing: Bool { get }
    var lastSyncDate: Date? { set get }
    
    func synchronize(clearStorage: Bool, completion: ((Bool, SWError?) -> Void)?)
    func clearData()
    func cancel()
}
