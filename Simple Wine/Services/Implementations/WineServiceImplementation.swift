import Foundation
import CoreData

final class WineServiceImplementation: WineService {
    
    private let apiClient: ApiClient
    private let dataStorage: ProductDataStorage
    
    init(apiClient: ApiClient = ApiClientImplementation()) {
        self.apiClient = apiClient
        self.dataStorage = ProductDataStorage()
    }
    
    func fetchWine(for bitrix_id: Int,
                           token: String,
                           deviceCode: String,
                           onSuccess: ((_ response: BaseWineshopResponse<ProductDetailPlainModel>?, _ task: URLSessionTask?, _ data: Data?) -> Void)?,
                           onFailure: ((_ error: SWError, _ task: URLSessionTask?, _ data: Data?) -> Void)?) -> URLSessionTask? {
        let wineRequest = FetchWineRequest(bitrix_id: bitrix_id, token: token, deviceCode: deviceCode)
        
        return makeRequest(request: wineRequest, onSuccess: { (response: BaseWineshopResponse<ProductDetailPlainModel>?, task: URLSessionTask?, data: Data?) in
            guard let response = response else {
                onSuccess?(nil, task, data)
                return
            }
            
            onSuccess?(response, task, data)

        }, onFailure: { (error, task, data) in
            SWLog(error: error)
            onFailure?(error, task, data)
        })
    }
    
//    func fetchFilteredWines(for filterOptions: FilterWinesOptions,
//                                    onSuccess: ((_ wines: FilterWinesResponse?, _ task: URLSessionTask?) -> Void)?,
//                                    onFailure: ((_ error: SWError, _ task: URLSessionTask?) -> Void)?) -> URLSessionTask? {
//
//        let wineRequest = FilterWinesRequest(filterOptions: filterOptions)
//        return makeRequest(request: wineRequest, onSuccess: onSuccess, onFailure: onFailure)
//    }
    
    func searchWines(query: String,
                 onSuccess: ((_ wines: WinesCollectionResponse?, _ task: URLSessionTask?, _ data: Data?) -> Void)?,
                 onFailure: ((_ error: SWError, _ task: URLSessionTask?, _ data: Data?) -> Void)?) -> URLSessionTask? {
        
//        let searchRequest = SearchWinesRequest(query: query)
//        return makeRequest(request: searchRequest, onSuccess: onSuccess, onFailure: onFailure)
        return nil
    }
    
    func obtainWine(by bitrixId: Int) -> ProductDetail? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ProductDetail")
        fetchRequest.predicate = NSPredicate(format: "bitrixId == %d", bitrixId)
        
        let result = try? CoreDataStack.shared.mainQueueContext.fetch(fetchRequest) as! [ProductDetail]
        
        return result?.first
//
//        let predicate = NSPredicate(format: "bitrix_id == %@", bitrix_id)
//        do {
//            return try self.cache.objects(predicate: predicate).first
//        } catch let error {
//            SWLog(error: error)
//            return nil
//        }
    }
    
    func obtainCountry(by name: String) -> ProductCountry? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ProductCountry")
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        
        let result = try? CoreDataStack.shared.mainQueueContext.fetch(fetchRequest) as! [ProductCountry]
        
        return result?.first
    }
    
    private func makeRequest<T>(request: BaseWineshopRequest<T>,
                                onSuccess: ((BaseWineshopResponse<T>, URLSessionTask?, Data?) -> Void)?,
                                onFailure: ((SWError, URLSessionTask?, Data?) -> Void)?) -> URLSessionTask? {
        return apiClient.makeRequest(request: request, onSuccess: { (response: BaseWineshopResponse<T>?, task: URLSessionTask?, data: Data?) in
            guard let response = response else {
                onFailure?(SWError.badRequestError, task, data)
                return
            }
            onSuccess?(response, task, data)
        }, onFailure: { (error: SWError, task: URLSessionTask?, data: Data?)  in
            onFailure?(error, task, data)
        })
    }
    
}
