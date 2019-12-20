import Foundation

struct Config {
    static let baseURL: URL = URL(string: "https://simplewine.ru/api/v1/jsonrpc" /* "http://s4.isimpleapp.ru/api/v1/jsonrpc" */ )!
    static let swaggerBaseURL: URL = URL(string: "https://simplewine.ru/api/v2" /* "http://dev6.simplewine.ru/api/v2" */)!
    static let contentBaseURL: URL = URL(string: "https://simplewine.ru" /* "http://dev6.simplewine.ru" */)!
    //FIXME: to be replaced when login API is ready
    static let vinothequeId = "9"
    static let productId = 930
    static let testLogin =  "kuznetsky.test@simplewine.ru" // */ "wineshop@simple.ru"
    static let testPassword =  "4fp1AoQ8@wUX" // */ "v8ll03R9Ognd"
}
