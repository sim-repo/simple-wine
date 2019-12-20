import Foundation

protocol WineService {
    //API
    func fetchWine(for bitrix_id: Int,
                           token: String,
                           deviceCode: String,
                       onSuccess: ((_ wines: BaseWineshopResponse<ProductDetailPlainModel>?, _ task: URLSessionTask?, _ data: Data?) -> Void)?,
                       onFailure: ((_ error: SWError, _ task: URLSessionTask?, _ data: Data?) -> Void)?) -> URLSessionTask?
//    func fetchFilteredWines(for filterOptions: FilterWinesOptions,
//                            onSuccess: ((_ wines: FilterWinesResponse?, _ task: URLSessionTask) -> Void)?,
//                            onFailure: ((_ error: SWError, _ task: URLSessionTask?) -> Void)?) -> URLSessionTask?
    func searchWines(query: String,
                     onSuccess: ((_ wines: WinesCollectionResponse?, _ task: URLSessionTask?, _ data: Data?) -> Void)?,
                     onFailure: ((_ error: SWError, _ task: URLSessionTask?, _ data: Data?) -> Void)?) -> URLSessionTask?
    //Cache
    func obtainWine(by bitrixId: Int) -> ProductDetail?
    func obtainCountry(by name: String) -> ProductCountry?
}
