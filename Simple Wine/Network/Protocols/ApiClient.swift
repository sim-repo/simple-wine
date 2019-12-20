import Foundation

typealias SuccessCallback<ResponseType> = (_ response: ResponseType?, _ task: URLSessionTask, _ data: Data?) -> Void
typealias FailureCallback<ErrorType> = (_ error: ErrorType, _ task: URLSessionTask?, _ data: Data?) -> Void

protocol ApiClient: class {
    func makeRequest<T: Request>(request: T,
                               onSuccess: @escaping SuccessCallback<T.ResponseType>,
                               onFailure: @escaping FailureCallback<SWError>) -> URLSessionTask?
}

