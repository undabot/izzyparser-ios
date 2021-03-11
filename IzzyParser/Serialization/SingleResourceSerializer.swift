import Foundation

class SingleResourceSerializer {
    
    private let validator: SerializationValidator = SerializationValidator()

    func parse(resource: Resource) -> SingleResourceJSON {
        let customKeys = type(of: resource).customKeys.reversed
        let attributes = parseAttributes(from: resource, with: customKeys)
        let relationships = parseRelationships(from: resource, with: customKeys)
        
        var data = [String: Any]()
        data.id = resource.id
        data.type = type(of: resource).type
        
        return SingleResourceJSON(data: data, attributes: attributes, relationships: relationships)
    }
    
    private func parseAttributes(from object: AnyObject, with customKeys: [String: String]? = nil) -> [String: Any] {
        guard let properties = (object as? NSObject)?.properties else {
            return [:]
        }
        
        var attributes = [String: Any]()
        
        for property in properties {
            let propertyName = customKeys?[property.name] ?? property.name
            let nestedPropertyValue = object.value(forKey: property.name) as AnyObject
            
            guard !validator.isNull(value: nestedPropertyValue) else {
                attributes[propertyName] = NSNull()
                continue
            }
            
            guard !validator.isNil(attributeName: property.name, in: object),
                !validator.isResource(value: nestedPropertyValue),
                !validator.isResourceCollection(nestedPropertyValue) else {
                    continue
            }
            
            if validator.isCollection(nestedPropertyValue) {
                attributes[propertyName] = parseCollection(from: nestedPropertyValue)
                continue
            }
            
            if validator.isObject(attributeValue: nestedPropertyValue) {
                attributes[propertyName] = parseAttributes(from: nestedPropertyValue)
            } else {
                attributes[propertyName] = nestedPropertyValue
            }
        }
        
        return attributes
    }
    
    private func parseRelationships(from resource: Resource, with customKeys: [String: String]) -> [String: Any] {
        let properties: [Property] = resource.properties
        var relationships = [String: Any]()
        
        for property in properties {
            let propertyName = customKeys[property.name] ?? property.name
            let propertyValue = resource.value(forKey: property.name) as AnyObject
            var propertyRelationships: Any?
            
            if validator.isResource(value: propertyValue) {
                propertyRelationships = extractRelationshipIdentity(from: propertyValue)
            } else if validator.isResourceCollection(propertyValue),
                let currentProperty = propertyValue as? [AnyObject] {
                propertyRelationships = parseResources(from: currentProperty)
            } else {
                continue
            }
            
            relationships[propertyName] = propertyRelationships
        }
        
        return relationships
    }
    
    private func parseResources(from array: [AnyObject]) -> [[String: Any]] {
        return array.map { extractRelationshipIdentity(from: $0) }
    }
    
    private func parseNonResources(from array: [AnyObject]) -> [[String: Any]] {
        return array.map { parseAttributes(from: $0) }
    }
    
    private func parseCollection(from object: AnyObject) -> Any? {
        guard !validator.isNonObjectCollection(object),
            let nestedAttribute = object as? [AnyObject]
            else {
                let value = replaceNullValues(in: object)
                return value
        }
        
        return parseNonResources(from: nestedAttribute)
    }
    
    private func replaceNullValues(in object: AnyObject) -> Any? {
        guard let collection = object as? [Any] else {
            return nil
        }
        
        return collection.map {
            return validator.isNull(value: $0) ? NSNull() : $0
        }
    }
    
    private func extractRelationshipIdentity(from object: AnyObject) -> [String: Any] {
        guard let object = object as? Resource else {
            return [:]
        }
        
        return object.identity.toDataDictionary()
    }
}
