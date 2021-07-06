import Foundation

public class Izzy {
    public var deserializer: Deserializer = IzzyDeserializer()
    public var serializer: Serializer = IzzySerializer()
    
    public init() {}
    
    /**
     Variable denoting if debug mode is on.
     If debug mode is on, Izzy log will be more verbose and additional errors instead of nullables can be thrown, with goal of pointing out potential usage issues.
     */
    public var isDebugModeOn = false {
        didSet {
            deserializer.isDebugModeOn = isDebugModeOn
        }
    }
    
    // MARK: - Deserialization
    
    /// Resources array contains all resource class types that should be deserialized from JSON
    /// E.g.: JSON contains `article` with relationships `author` and `comment`
    /// Than resource map should be:
    /// [Article.self, Author.self, Comment.self]
    public func registerResources(resources: [Resource.Type]) {
        let resourceMap = resources.reduce(into: [String: Resource.Type]()) { $0[$1.type] = $1 }
        deserializer.registerResources(resourceMap: resourceMap)
    }
    
    /**
     Method for deserializing single resource.
     
     - parameter data: Data containing JSONAPI document
     - returns: Document object with deserialized resource
     - throws: error if JSONSerialization fails or JSONAPI specification is not satisfied
     
     */
    public func deserializeResource<T: Resource>(from data: Data) throws -> Document<T> {
        return try deserializer.deserialize(data)
    }
    
    /**
     Method for deserializing resource collection.
     
     - parameter data: Data containing JSONAPI document
     - returns: Document object with deserialized resource collection
     - throws: error if JSONSerialization fails or JSONAPI specification is not satisfied
     
     */
    public func deserializeCollection<T: Resource>(_ data: Data) throws -> Document<[T]> {
        return try deserializer.deserializeCollection(data)
    }
    
    // MARK: - Serialization
    
    /**
     Method for serializing single resource. For internal usage only.
     
     - parameter resource: Resource object
     - returns: serialized resource dictionary
     
     */
    func serialize(resource: Resource) -> [String: Any] {
        return serializer.serialize(resource: resource)
    }
    
    /**
     Method for serializing collection of resources.
     
     - parameter resourceCollection: An array of resource objects
     - returns: dictionary with serialized resource collection as "data" value
     
     */
    public func serialize(resourceCollection: [Resource]) -> [String: Any] {
        return serializer.serialize(resourceCollection: resourceCollection)
    }
    
    /**
     Method for serializing single resource object with custom attribute dictionary.
     
     - parameter resource: Resource object
     - parameter attributeKey: JSON key whose value should be replaced with attributeValue
     - parameter attributeValue: attribute JSON value
     - returns: dictionary with serialized resource
     
     */
    public func serializeCustom(resource: Resource, attributeKey: String, attributeValue: Any?) -> [String: Any] {
        return serializer.serialize(resource, attributeKey: attributeKey, attributeValue: attributeValue)
    }
    
    /**
     Method for serializing single resource object with custom relationship dictionary.
     
     - parameter resource: Resource object
     - parameter relationshipKey: JSON key whose value should be replaced with attributeValue
     - parameter relationshipValue: relationship JSON value
     - returns: dictionary with serialized resource
     
     */
    public func serializeCustom(resource: Resource, relationshipKey: String, relationshipValue: Any) -> [String: Any] {
        return serializer.serialize(resource, relationshipKey: relationshipKey, relationshipValue: relationshipValue)
    }
}
