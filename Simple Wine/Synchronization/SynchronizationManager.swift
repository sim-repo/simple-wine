import Foundation
import UIKit

// MARK: - Notifications

extension Notification.Name {
    static let synchronizationDidStart = Notification.Name("synchronizationDidStart")
    static let synchronizationDidFinish = Notification.Name("synchronizationDidFinish")
}


// MARK: -

class SynchronizationManager {
    
    // MARK: - Public Properties
    
    var configuration: SyncConfiguration!
    var authService: AuthService!
    var synchronizers: [Synchronizer]!
    
    var isSyncing: Bool {
        return self.dispatchGroup != nil
    }
    
    var lastSyncDate: Date? {        
        return synchronizers.filter{ $0.lastSyncDate != nil }.sorted{ $0.lastSyncDate! > $1.lastSyncDate! }.first?.lastSyncDate
    }
    
    var lastSyncDateString: String {
        var lastSyncDateString = "никогда"
        if let lastSyncDate = self.lastSyncDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .long
            dateFormatter.timeStyle = .short
            dateFormatter.locale = Locale(identifier: "ru")
            lastSyncDateString = dateFormatter.string(from: lastSyncDate)
        }
        
        return lastSyncDateString
    }
    
    
    // MARK: - Private Properties
    
    private var dispatchGroup: DispatchGroup?
    private var backgroundTaskID: UIBackgroundTaskIdentifier?
    
    
    // MARK: - Singleton Initialization
    
    static let shared = SynchronizationManager()
    
    private init() {
        // SynchronizationManager needs to be configured with 'setup' method
    }
    
    func setup(authService: AuthService, configuration: SyncConfiguration) {
        self.authService = authService
        self.configuration = configuration
        
        // Setup synchronizers
        self.synchronizers = [CategoriesSynchronizer(authService: self.authService, cardType: .classic),
                              CategoriesSynchronizer(authService: self.authService, cardType: .price)]
    }
    
    
    // MARK: - Public Methods
    
    @objc func startSync() {
        startSync(forced: false, completion: nil)
    }
    
    func startSync(forced: Bool = false, completion: ((Bool, SWError?) -> Void)? = nil) {
        // Validate authorization
        if self.authService.token == nil {
            if let completion = completion {
                completion(false, SWError.unauthorizedAccess)
            }
            
            return
        }
        
        // If sync is forced need to cancel all current tasks
        if forced {
            cancel()
        }
        
        // No need to sync if already started
        if self.isSyncing {
            if let completion = completion {
                completion(false, nil)
            }
            
            return
        }
        
        // Check that more than one day has passed since last sync
        var forceSync = forced
        let today = Date()
        if !forceSync, let lastSyncDate = self.lastSyncDate {
            // Check if synced less than an sync interval
            if today.timeIntervalSince(lastSyncDate) < self.configuration.interval {
                if let completion = completion {
                    completion(true, nil)
                }
                
                return
            }
            
            // Check if tomorrow morning
            if today.noon != lastSyncDate.noon && Date.hoursBetween(start: lastSyncDate, end: today) > 6 {
                forceSync = true
            }
        }
        
        // Check if current time is allowed for sync
        let isSyncAllowedTime = today.isBetween(self.configuration.startTime, and: self.configuration.endTime)
        if !forceSync && hasSynchronizedData() && !isSyncAllowedTime {
            // No need to sync at this time
            if let completion = completion {
                completion(true, nil)
            }
            
            return
        }
        
        
        // Setup background task so syncronization will continue if app goes to background state
        self.backgroundTaskID = UIApplication.shared.beginBackgroundTask (withName: "com.simplewine.simplewinelist.SyncServiceBackgroundTask") {
            UIApplication.shared.endBackgroundTask(self.backgroundTaskID!)
            self.backgroundTaskID = UIBackgroundTaskIdentifier.invalid
        }
        
        // Create synchronization dispatch group
        self.dispatchGroup = DispatchGroup()
        
        // Notify synchronization started
        NotificationCenter.default.post(name: .synchronizationDidStart, object: nil)
        
        let startSyncTime = Date() // just for debug test
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }
            
            var synchronizationError: SWError?
            
            // Start every synchronizer
            for synchronizer in self.synchronizers {
                if synchronizationError != nil {
                    break
                }
                
                self.dispatchGroup?.enter()
                synchronizer.synchronize(clearStorage: false, completion: { [weak self] (success, error) in
                    guard let self = self else { return }
                    
                    if let error = error {
                        synchronizationError = error
                    }
                    
                    self.dispatchGroup?.leave()
                })
            }
            
            // Perform when sync will be finished
            self.dispatchGroup?.notify(queue: DispatchQueue.main, execute: {
                [weak self] in
                guard let self = self else { return }
                
                self.dispatchGroup = nil
                
                if let error = synchronizationError {
                    if let completion = completion {
                        completion(false, SWError.syncError)
                    }
                    
                    SWLog("Sync finished with error: \(error)")
                }
                else {                    
                    if let completion = completion {
                        completion(true, nil)
                    }
                    
                    let duration = Date().timeIntervalSince(startSyncTime)
                    SWLog("Sync finished. Sync duration: \(Int(duration)) seconds.")
                }
                
                // Notify synchronization finished
                NotificationCenter.default.post(name: .synchronizationDidFinish, object: nil)
                
                // Schedule next sync
                self.scheduleNextSync()
                
                // If app in background state then update system that we are done!
                UIApplication.shared.endBackgroundTask(self.backgroundTaskID!)
                self.backgroundTaskID = UIBackgroundTaskIdentifier.invalid
            })
        }
    }
    
    func cancel() {
        // Stop all
        self.synchronizers.forEach() { $0.cancel() }
        
        // Reset current dispatch group
        self.dispatchGroup = nil
    }
    
    func clearData() {
        // Stop all current tasks
        cancel()
        
        // Clear storage
        self.synchronizers.forEach() { $0.clearData() }
    }
    
    func hasSynchronizedData() -> Bool {
        // Find synchronizers which has no data
        let emptySynchronizers = self.synchronizers.filter { $0.lastSyncDate == nil }
        return emptySynchronizers.isEmpty
    }
    
    
    // MARK: - Private Methods
    
    private func scheduleNextSync() {
        if let lastSyncDate = self.lastSyncDate {
            let date = lastSyncDate.addingTimeInterval(self.configuration.interval)
            let timer = Timer(fireAt: date, interval: 0, target: self, selector: #selector(startSync), userInfo: nil, repeats: false)
            RunLoop.main.add(timer, forMode: .common)
        }
    }
    
}
