import Foundation

final class WineshopServiceImplementation: WineshopService {
    
    private let apiClient: ApiClient
    
    init(apiClient: ApiClient = ApiClientImplementation()) {
        self.apiClient = apiClient
    }
    
    func fetchAvailableSystemDevice(onSuccess: ((BaseWineshopResponse<SystemDevicePlainModel>, URLSessionTask?, Data?) -> Void)?,
                                    onFailure: ((SWError, URLSessionTask?, Data?) -> Void)?) -> URLSessionTask? {
        let request = SystemDeviceRequest()
        return apiClient.makeRequest(request: request, onSuccess: { (response: BaseWineshopResponse<SystemDevicePlainModel>?, task: URLSessionTask?, data: Data?) in
            guard let response = response else {
                onFailure?(SWError.badRequestError, task, data)
                return
            }
            onSuccess?(response, task, data)
        }, onFailure: { (error: SWError, task: URLSessionTask?, data: Data?) in
            onFailure?(error, task, data)
        })
    }
    
    func fetchAvailableConfig(onSuccess: ((BaseWineshopResponse<ConfigPlainModel>, URLSessionTask?, Data?) -> Void)?,
                              onFailure: ((SWError, URLSessionTask?, Data?) -> Void)?) -> URLSessionTask? {
        let request = ConfigRequest()
        return apiClient.makeRequest(request: request, onSuccess: { (response: BaseWineshopResponse<ConfigPlainModel>?, task: URLSessionTask?, data: Data?) in
            guard let response = response else {
                onFailure?(SWError.badRequestError, task, data)
                return
            }
            onSuccess?(response, task, data)
        }, onFailure: { (error: SWError, task: URLSessionTask?, data: Data?) in
            onFailure?(error, task, data)
        })
    }
    
    func fetchAvailableCategories(token: String,
                                  deviceCode: String,
                                  type: WineMapMode,
                                  onSuccess: ((BaseWineshopResponse<[CategoryPlainModel]>, URLSessionTask?, _ data: Data?) -> Void)?,
                                  onFailure: ((SWError, URLSessionTask?, Data?) -> Void)?) -> URLSessionTask? {
        let request = AvailableCategoriesRequest(token: token, deviceCode: deviceCode, type: type)
        return apiClient.makeRequest(request: request, onSuccess: { (response: BaseWineshopResponse<[CategoryPlainModel]>?, task: URLSessionTask?, data: Data?) in
            guard let response = response else {
                onFailure?(SWError.badRequestError, task, data)
                return
            }
            onSuccess?(response, task, data)
        }, onFailure: { (error: SWError, task: URLSessionTask?, data: Data?) in
            onFailure?(error, task, data)
        })
    }
    
    func fetchAvailableSubCategories(for token: String,
                                     deviceCode: String,
                                     categoryId: UInt,
                                     filters: [[String]],
                                     type: WineMapMode,
                                     onSuccess: ((BaseWineshopResponse<[CategoryPlainModel]>, URLSessionTask?, Data?) -> Void)?,
                                     onFailure: ((SWError, URLSessionTask?, Data?) -> Void)?) -> URLSessionTask? {
        let request = AvailableCategoriesRequest(categoryId: categoryId, token: token, filters: filters, type: type)
        return apiClient.makeRequest(request: request, onSuccess: { (response: BaseWineshopResponse<[CategoryPlainModel]>?, task: URLSessionTask?, data: Data?) in
            guard let response = response else {
                onFailure?(SWError.badRequestError, task, data)
                return
            }
            
            onSuccess?(response, task, data)
        }, onFailure: { (error: SWError, task: URLSessionTask?, data: Data?) in
            onFailure?(error, task, data)
        })
    }
    
    func fetchAvailableWines(for subCategoryId: UInt,
                             token: String,
                             deviceCode: String,
                             type: WineMapMode,
                             filters: [[String]],
                             page: Int,
                             onSuccess: ((_ response: BaseWineshopResponse<AvailableProductsPlainModel>, _ task: URLSessionTask?, _ data: Data?) -> Void)?,
                             onFailure: ((_ error: SWError, _ task: URLSessionTask?, _ data: Data?) -> Void)?) -> URLSessionTask? {
        let request = AvailableWinesRequest(subCategoryId: subCategoryId, type: type, token: token, deviceCode: deviceCode, filters: filters, page: page)
        return makeRequest(request: request, onSuccess: onSuccess, onFailure: onFailure)
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
        }, onFailure: { (error: SWError, task: URLSessionTask?, data: Data?) in
            onFailure?(error, task, data)
        })
    }
    
}
