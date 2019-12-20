import Foundation
import CoreData

class CategoriesSynchronizer: Synchronizer {
            
    // MARK: - Public Properties
    
    let authService: AuthService!
    let cardType: WineMapMode!
    let wineshopService: WineshopService!
    
    var lastSyncDate: Date? {
        get {
            return UserDefaults.standard.value(forKey: lastSyncDefaultsKey) as? Date
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: lastSyncDefaultsKey)
        }
    }
    
    var lastSyncDefaultsKey: String {
        return self.cardType.description + "_" + Constants.UserDefaults.lastSyncDate
    }
    
    // MARK: - Private Properties
    
    private var categoryDataStorage: DataStorage
    private var productDataStorage: DataStorage
    
    private var dispatchGroup: DispatchGroup?
    private var activeTasks = [URLSessionTask]()
    private var data = [String : String]()
    private var synchronizationError: SWError?
    private var taskContext: NSManagedObjectContext
    
    private var syncStart: Date!
    
    
    // MARK: - Initialization
    
    required init(authService: AuthService, cardType: WineMapMode) {
        self.authService = authService
        self.cardType = cardType
        
        self.taskContext = CoreDataStack.shared.newPrivateQueueContext
        
        self.wineshopService = WineshopServiceImplementation()
        
        self.categoryDataStorage = CategoryDataStorage(cardType: self.cardType, context: self.taskContext)
        self.productDataStorage = ProductDataStorage(context: self.taskContext)
    }
    
    
    // MARK: - Public methods
    
    var isSyncing: Bool {
        return self.dispatchGroup != nil
    }
    
    func synchronize(clearStorage: Bool = false, completion: ((Bool, SWError?) -> Void)? = nil) {
        // Reset current state
        resetSyncState()
        
        // Clear cached data if needed
        if clearStorage {
            self.categoryDataStorage.clearAll()
        }
        
        // Create synchronization dispatch group
        self.dispatchGroup = DispatchGroup()
        self.taskContext.reset()
        
        // Load data
        self.syncStart = Date()
        
        loadCategories()
        
        // Perform when sync will be finished
        self.dispatchGroup?.notify(queue: DispatchQueue.global(qos: .background), execute: {
            [weak self] in
            guard let self = self else { return }
            
            self.dispatchGroup = nil
            
            // Save data
            if self.taskContext.hasChanges {
                do {
                    try self.taskContext.save()
                } catch {
                    SWLog(error: error)
                    return
                }
            }
            
            // Clear deleted data
            self.categoryDataStorage.clear(before: self.syncStart)
            self.productDataStorage.clear(before: self.syncStart)
            
            // Process completion
            if let error = self.synchronizationError {                
                if let completion = completion {
                    completion(false, error)
                }
                
                SWLog("Sync \(self.cardType.description) categories finished with error: \(error)")
            }
            else {
                if let completion = completion {
                    completion(true, nil)
                }
            }
            
            // Update last sync date
            self.lastSyncDate = Date()
        })
    }
    
    func cancel() {
        self.activeTasks.forEach() { $0.cancel() }
    }
    
    
    func clearData() {
        self.lastSyncDate = nil
        self.categoryDataStorage.clearAll()
        self.productDataStorage.clearAll()
    }
    
    
    // MARK: - Private methods
    
    private func resetSyncState() {
        self.synchronizationError = nil
    }
    
    
    private func loadCategories() {
        let task = self.wineshopService.fetchAvailableCategories(token: self.authService.token!, deviceCode: self.authService.deviceCode!, type: self.cardType, onSuccess: { [weak self] (response, task, data) in
            guard let self = self, let task = task else { return }
            
            if task.state != .canceling, let data = data {
                self.data.removeAll()
                self.data[Constants.NetworkService.Keys.category] = String(data: data, encoding: .utf8)!
                
                if let categories = response.value {
                    for (index, categoryData) in categories.enumerated() {
                        if let category = self.categoryDataStorage.insertNewObject(categoryData) as? Category {
                            category.key = "\(self.cardType!.rawValue)_\(category.categoryId)_\(category.name)"
                            category.cardType = self.cardType!.rawValue
                            category.order = index
                            
                            self.loadSubCategories(category: category)
                        }
                    }
                }
            }
            
            self.activeTasks.remove(object: task)
            self.dispatchGroup?.leave()
        }) { [weak self] (error, task, data) in
            guard let self = self else { return }
            
            self.dispatchGroup?.leave()
            
            self.cancel()
            self.synchronizationError = error
        }
        
        if let task = task {
            self.dispatchGroup?.enter()
            self.activeTasks.append(task)
        }
    }
    
    private func loadSubCategories(category: Category) {
        let deeplink = category.deeplink
        var filters = [[String]]()
        let urlItems = deeplink.components(separatedBy: "?")
        if urlItems.count > 1 {
            let queryItems = urlItems[1].components(separatedBy: "&")
            for queryItem in queryItems {
                filters.append(queryItem.components(separatedBy: "="))
            }
        }
        
        if deeplink.contains(Constants.NetworkService.Keys.products) {
            loadProduct(category: category, filters: filters)
        }
        else if deeplink.contains(Constants.NetworkService.Keys.categories) {
            loadCategory(category: category, filters: filters)
        }
    }
    
    private func loadCategory(category parentCategory: Category, filters: [[String]]) {        
        let task = self.wineshopService.fetchAvailableSubCategories(for: self.authService.token!, deviceCode: self.authService.deviceCode!, categoryId: parentCategory.categoryId, filters: filters, type: self.cardType, onSuccess: { [weak self] (response, task, data) in
            guard let self = self, let task = task else { return }
            
            if task.state != .canceling {
                if let categories = response.value {
                    for (index, categoryData) in categories.enumerated() {
                        // Task 25601504: по цене - фильтр до 1500 руб - не выводить
                        if self.cardType == .price, let categoryName = categoryData.name, categoryName.hasSuffix("1 500") {
                            continue
                        }
                        
                        if let category = self.categoryDataStorage.insertNewObject(categoryData) as? Category {
                            category.order = index
                            category.key = "\(parentCategory.key)_\(category.categoryId)_\(category.name)"
                            category.cardType = self.cardType!.rawValue
                            category.parentCategory = parentCategory
                            
                            self.loadSubCategories(category: category)
                        }
                    }
                }
            }
            
            self.activeTasks.remove(object: task)
            self.dispatchGroup?.leave()
        }) { [weak self] (error, task, data) in
            guard let self = self else { return }
            
            self.dispatchGroup?.leave()
            
            self.cancel()
            self.synchronizationError = error
        }
        
        if let task = task {
            self.dispatchGroup?.enter()
            self.activeTasks.append(task)
        }
    }
    
    private func loadProduct(category: Category, filters: [[String]], page: Int = 1) {
        let task = self.wineshopService.fetchAvailableWines(for: category.categoryId, token: self.authService.token!, deviceCode: self.authService.deviceCode!, type: self.cardType, filters: filters, page: page, onSuccess: { [weak self] (response, task, data) in
            guard let self = self, let task = task else { return }
            
            if task.state != .canceling {
                if let products = response.value, let wines = products.wines {
                    let count = products.count
                    var workCategory = category
                    if wines.count == 0 {
                        let parent = category.parentCategory
                        parent?.removeFromChildCategories(category)
                        
                        if let parent = parent, parent.childCategories?.count == 0 {
                            self.categoryDataStorage.delete(parent)
                        }
                        self.categoryDataStorage.delete(category)
                    } else if let all = (category.filters.first{ ($0.first {$0 == "all_regions" }) != nil }), all.count>1, all[1] == "true", count < 50{
                        if let parent = category.parentCategory {
                            parent.deeplink = category.deeplink
                            workCategory = parent
                        }
                    }
                    for (index, wineData) in wines.enumerated() {
                        let product = self.productDataStorage.insertNewObject(wineData) as! Product
                        product.key = "\(category.key)_\(product.bitrixId)_\(product.name ?? "")"
                        product.order = index
                        product.category = workCategory
                        
                        // Task 25601634: не выводить в списке всех продуктов названия, которые в скобках
                        product.name = product.name!.replacingOccurrences(of: "\\s\\((.*?)\\)", with: "", options: .regularExpression)
                    }
                    
                    if products.total > products.page {
                        self.loadProduct(category: category, filters: filters, page: products.page+1)
                    }
                }
            }
            
            self.activeTasks.remove(object: task)
            self.dispatchGroup?.leave()
        }) { [weak self] (error, task, data) in
            guard let self = self else { return }
            
            self.dispatchGroup?.leave()
            
            self.cancel()
            self.synchronizationError = error
        }
        
        if let task = task {
            self.dispatchGroup?.enter()
            self.activeTasks.append(task)
        }
    }
    
    private func clearLegacyData() {
        if let lastUpdate = self.syncStart {
            self.categoryDataStorage.clear(before: lastUpdate)
        }
    }
}
