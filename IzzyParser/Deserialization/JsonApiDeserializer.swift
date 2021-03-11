import Foundation

public typealias JSONApi = [String: Any]

class JSONApiDeserializer {
    
    func deserializeJSONApi(from document: [String: Any]) -> JSONApi? {
        return document["jsonapi"] as? JSONApi
    }
}
