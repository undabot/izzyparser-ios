import Foundation
import ObjectiveC.runtime

public class IzzySerializer: Serializer {
    
    private let singleSerializer = SingleResourceSerializer()
    private let collectionSerializer = ResourceCollectionSerializer()
    
    /**
     Method for serializing single resource object.
     
     - parameter resource: Resource object
     - returns: serialized resource dictionary as value for "data" key
     
     */
    public func serialize(resource: Resource) -> [String: Any] {
        
        // Serialize resource
        let dictionary = singleSerializer.parse(resource: resource)
        
        let resourceJson = SingleResourceJSON(data: dictionary.data, attributes: dictionary.attributes, relationships: dictionary.relationships)
        
        // Append `attributes` and `relationships` into `data`
        var document = [String: Any]()
        document.data = resourceJson.toDataDictionary()

        return document
    }
    
    /**
     Method for serializing single resource object with custom attribute dictionary.
     
     - parameter resource: Resource object
     - parameter attributeKey: JSON key whose value should be replaced with attributeValue
     - parameter attributeValue: attribute JSON value
     - returns: dictionary with serialized resource as "data" value
     
     */
    public func serialize(_ resource: Resource, attributeKey: String, attributeValue: Any) -> [String: Any] {
        
        // Serialize resource
        let dictionary = singleSerializer.parse(resource: resource)
        
        // Update value for key in serialized dictionary
        var attributes = dictionary.attributes
        attributes.updateValue(attributeValue, forKey: attributeKey)
        
        let resourceJson = SingleResourceJSON(data: dictionary.data, attributes: attributes, relationships: dictionary.relationships)
        
        // Append `attributes` and `relationships` into `data`
        var document = [String: Any]()
        document.data = resourceJson.toDataDictionary()

        return document
    }
    
    /**
     Method for serializing single resource object with custom relationship dictionary.
     
     - parameter resource: Resource object
     - parameter relationshipKey: JSON key whose value should be replaced with attributeValue
     - parameter relationshipValue: relationship JSON value
     - returns: dictionary with serialized resource as "data" value
     
     */
    public func serialize(_ resource: Resource, relationshipKey: String, relationshipValue: Any) -> [String: Any] {
        
        let dictionary = singleSerializer.parse(resource: resource)
        
        var relationships = dictionary.relationships
        relationships.updateValue(relationshipValue, forKey: relationshipKey)
        
        let resourceJson = SingleResourceJSON(data: dictionary.data, attributes: dictionary.attributes, relationships: relationships)
        
        var document = [String: Any]()
        document.data = resourceJson.toDataDictionary()

        return document
    }
    
    /**
     Method for serializing collection of resources.
     
     - parameter resourceCollection: An array of resource objects
     - returns: dictionary with serialized resource collection as "data" value
     
     */
    public func serialize(resourceCollection: [Resource]) -> [String: Any] {
        
        let dictionary = collectionSerializer.parse(collection: resourceCollection)
        
        var document = [String: Any]()
        document.data = dictionary

        return document
    }
}
