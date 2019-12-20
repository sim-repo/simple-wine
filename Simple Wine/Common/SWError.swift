import Foundation

private let defaultDomain: String = "com.SimpleWine.errors"
private let defaultErrorCode: Int = -1

final class SWError: NSError {
    
    private(set) var title: String = ""
    private(set) var message: String = ""
    
    init(title: String, message: String) {
        super.init(domain: defaultDomain, code: defaultErrorCode, userInfo: nil)
        self.title = title
        self.message = message
    }
    
    init(title: String, message: String, code: Int) {
        super.init(domain: defaultDomain, code: code, userInfo: nil)
        self.title = title
        self.message = message
    }
    
    init(error: NSError, title: String, message: String) {
        super.init(domain: error.domain, code: error.code, userInfo: error.userInfo)
        self.title = title
        self.message = message
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

@inline(__always)
func SWLog(error: Error) {
    #if DEBUG
        print("\(#file):\(#line)l: \(error)")
    #endif
}

@inline(__always)
func SWLog(_ message: String) {
    #if DEBUG
        print("\(#file):\(#line)l: \(message)")
    #endif
}

extension SWError {
    static var badRequestError: SWError {
        return SWError(
            title: Localization.ApiErrors.badRequestTitle,
            message: Localization.ApiErrors.badRequestMessage
        )
    }
    static var syncError: SWError {
        return SWError(
            title: Localization.ApiErrors.syncErrorTitle,
            message: Localization.ApiErrors.syncErrorMessage
        )
    }
    static var parseError: SWError {
        return SWError(
            title: Localization.ParseErrors.parseErrorTitle,
            message: Localization.ParseErrors.parseErrorMessage
        )
    }
    static var cacheError: SWError {
        return SWError(
            title: Localization.CacheErrors.cacheSaveErrorTitle,
            message: Localization.CacheErrors.cacheSaveErrorMessage
        )
    }
    static var unauthorizedAccess: SWError {
        return SWError(
            title: Localization.ApiErrors.badRequestTitle,
            message: Localization.ApiErrors.badRequestMessage
        )
    }
    static var unsupportedPlainModel: SWError {
        return SWError(
            title: Localization.ApiErrors.badRequestTitle,
            message: Localization.ApiErrors.badRequestMessage
        )
    }
}
