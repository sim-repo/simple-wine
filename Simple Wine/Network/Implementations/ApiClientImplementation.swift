import Foundation

final class ApiClientImplementation: ApiClient {

    private let urlSession: URLSessionProtocol
    private let parser: Parser
    
    init(parser: Parser = JSONParser()) {
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.httpMaximumConnectionsPerHost = 5
        sessionConfig.timeoutIntervalForRequest = 300.0
        sessionConfig.timeoutIntervalForResource = 900.0
        self.urlSession = URLSession(configuration: sessionConfig)
        self.parser = parser
    }
    
    func makeRequest<T>(request: T,
                      onSuccess: @escaping (T.ResponseType?, URLSessionTask, Data?) -> Void,
                      onFailure: @escaping (SWError, URLSessionTask?, Data?) -> Void) -> URLSessionTask? where T : Request {
        
        let urlRequest: URLRequest
        do {
            urlRequest = try request.urlRequest()
        } catch let error {
            SWLog(error: error)
            onFailure(SWError.badRequestError, nil, nil)
            return nil
        }
    
        var task: URLSessionTask!
        
        print("+++ \(urlRequest.url?.absoluteString.removingPercentEncoding ?? "")")
        task = QueueManager.instance.push(request: urlRequest, completionHandler: { [weak self] (data: Data?, response: URLResponse?, error: Error?) in
                        if let sself = self,
                (error as NSError?)?.code != NSURLErrorCancelled {
                if let error = error {
                    SWLog(error: error)
                    onFailure(SWError.badRequestError, task, data)
                } else {
                    do {
                        if let data = data {
                            let result: T.ResponseType = try sself.parser.parse(data: data)
                            if let _result = result as? (BaseWineshopResponse<AvailableProductsPlainModel>), let product = _result.value {
                                
                                if product.total > 1 {
                                    print("??? \(product.total) [\(product.page)] \(urlRequest.url?.absoluteString.removingPercentEncoding ?? "")")
                                }
                                
                                if let wines = product.wines, wines.count == 0 {
                                    print("==================================== Empty\n \(urlRequest.url?.absoluteString.removingPercentEncoding ?? "")\n\n")
                                    print("\(String(data: data, encoding: String.Encoding.utf8) ?? "erroor decoding")")
                                    print("==================================== <<<< \n")
                                }
                            }
                            onSuccess(result, task, data)
                        } else {
                            onSuccess(nil, task, data)
                        }
                    } catch let error {
                        SWLog(error: error)
                        onFailure(SWError.parseError, task, data)
                    }
                }
            } else {
                onFailure(SWError.parseError, task, data)
            }
        })
        
//        task = self.urlSession.dataTask(with: urlRequest) { [weak self] (data: Data?, response: URLResponse?, error: Error?) in
//
//            if let sself = self,
//                (error as NSError?)?.code != NSURLErrorCancelled {
//                if let error = error {
//                    SWLog(error: error)
//                    onFailure(SWError.badRequestError, task, data)
//                } else {
//                    do {
//                        if let data = data {
//                            let result: T.ResponseType = try sself.parser.parse(data: data)
//                            //(result as? BaseWineshopResponse<AvailableProductsPlainModel>)?.value
//                            if let _result = result as? (BaseWineshopResponse<AvailableProductsPlainModel>) {
//                                if let product = _result.value, let wines = product.wines, wines.count == 0 {
//                                    print("==================================== Empty\n \(urlRequest.url?.absoluteString.removingPercentEncoding ?? "")\n\n")
//                                    print("\(String(data: data, encoding: String.Encoding.utf8) ?? "erroor decoding")")
//                                    print("==================================== <<<< \n")
//                                }
//                            }
//                            onSuccess(result, task, data)
//                        } else {
//                            onSuccess(nil, task, data)
//                        }
//                    } catch let error {
//                        SWLog(error: error)
//                        onFailure(SWError.parseError, task, data)
//                    }
//                }
//            } else {
//                onFailure(SWError.parseError, task, data)
//            }
//        }
//
//        task.resume()
        return task
    }
}
