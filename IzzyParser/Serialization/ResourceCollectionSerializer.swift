import Foundation

class ResourceCollectionSerializer {
    
    private let singleSerializer = SingleResourceSerializer()
    
    func parse(collection: [Resource]) -> [[String: Any]] {
        return collection.map { serializeSingle(resource: $0) }
    }
    
    private func serializeSingle(resource: Resource) -> [String: Any] {
        let singleResource = singleSerializer.parse(resource: resource)
        
        return singleResource.toDataDictionary()
    }
}
