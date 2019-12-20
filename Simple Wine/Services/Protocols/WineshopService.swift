import Foundation

protocol WineshopService: class {
    
    func fetchAvailableSystemDevice(onSuccess: ((_ response: BaseWineshopResponse<SystemDevicePlainModel>, _ task: URLSessionTask?, _ data: Data?) -> Void)?,
                                    onFailure: ((_ error: SWError, _ task: URLSessionTask?, _ data: Data?) -> Void)?) -> URLSessionTask?
    
    func fetchAvailableConfig(onSuccess: ((_ response: BaseWineshopResponse<ConfigPlainModel>, _ task: URLSessionTask?, _ data: Data?) -> Void)?,
                              onFailure: ((_ error: SWError, _ task: URLSessionTask?, _ data: Data?) -> Void)?) -> URLSessionTask?
    
    func fetchAvailableCategories(token: String,
                                  deviceCode: String,
                                  type: WineMapMode,
                                  onSuccess: ((_ response: BaseWineshopResponse<[CategoryPlainModel]>, _ task: URLSessionTask?, _ data: Data?) -> Void)?,
                                  onFailure: ((_ error: SWError, _ task: URLSessionTask?, _ data: Data?) -> Void)?) -> URLSessionTask?
    
    func fetchAvailableSubCategories(for token: String,
                                     deviceCode: String,
                                     categoryId: UInt,
                                     filters: [[String]],
                                     type: WineMapMode,
                                     onSuccess: ((_ response: BaseWineshopResponse<[CategoryPlainModel]>,
        _ task: URLSessionTask?, _ data: Data?) -> Void)?,
                                     onFailure: ((_ error: SWError, _ task: URLSessionTask?, _ data: Data?) -> Void)?) -> URLSessionTask?
    
    func fetchAvailableWines(for subCategoryId: UInt,
                             token: String,
                             deviceCode: String,
                             type: WineMapMode,
                             filters: [[String]],
                             page: Int,
                             onSuccess: ((_ response: BaseWineshopResponse<AvailableProductsPlainModel>, _ task: URLSessionTask?, _ data: Data?) -> Void)?,
                             onFailure: ((_ error: SWError, _ task: URLSessionTask?, _ data: Data?) -> Void)?) -> URLSessionTask?
    
}
