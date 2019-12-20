import Foundation

protocol Parser {
    func parse<T: Decodable>(data: Data) throws -> T
}

final class JSONParser: Parser {
    
    let jsonDecoder = JSONDecoder()
    
    func parse<T>(data: Data) throws -> T where T : Decodable {
        return try self.jsonDecoder.decode(T.self, from: data)
    }
}
