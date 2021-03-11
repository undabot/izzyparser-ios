import Foundation

public typealias Meta = [String: Any]

class MetaDeserializer {
    
    func deserializeMeta(from document: [String: Any]) -> Meta? {
        return document.meta
    }
}
