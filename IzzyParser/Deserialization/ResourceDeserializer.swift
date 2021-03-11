import Foundation

class ResourceDeserializer {

    var resourceMap: [String: Resource.Type]?
    var linksDeserializer = LinksDeserializer()
    var metaDeserializer = MetaDeserializer()
    var isDebugModeOn: Bool
    
    init(isDebugModeOn: Bool = false) {
        self.isDebugModeOn = isDebugModeOn
    }

    func deserializeResource<T: Resource>(from dataJSONDictionary: [String: Any]) throws -> T? {
        // If `id` or `type` are missing from dictionary, specification is not satisfied.
        guard let id = dataJSONDictionary.id,
            let type = dataJSONDictionary.type else {
                throw IzzyError.invalidJSONAPIResponse
        }
        
        // Resource map needs to be set for deserialization.
        guard let resourceType = resourceMap?[type] else {
            if isDebugModeOn {
                throw IzzyError.unregisteredResource(type: type)
            } else {
                return nil
            }
        }

        let resource = resourceType.init(id: id)

        setAttributes(on: resource, with: dataJSONDictionary.attributes)
        setRelationships(on: resource, with: dataJSONDictionary.relationships)
        setLinks(on: resource, with: dataJSONDictionary)
        setMeta(on: resource, with: dataJSONDictionary)
        
        return resource as? T
    }
    
    private func setAttributes(on resource: Resource, with attributes: [String: Any]?) {
        guard let attributes = attributes else {
            return
        }

        attributes.forEach { setValue($0.value, for: $0.key, on: resource) }
    }
    
    private func setValue(_ value: Any, for key: String, on resource: Resource) {
        guard !(value is NSNull) else {
            return
        }

        let resourceType = type(of: resource)
        let newValue = customValue(for: value, key: key, resourceType: resourceType)
        let customKey = resourceType.customKeys[key] ?? key

        resource.setValueIfPossible(value: newValue, for: customKey)
    }

    private func customValue(for currentValue: Any, key: String, resourceType: Resource.Type) -> Any? {
        let customKey = resourceType.customKeys[key] ?? key
        
        guard resourceType.typesForKeys.keys.contains(customKey) else { return currentValue }
        
        if let objectForKey = currentValue as? [String: Any] {
            return getCustomObject(for: customKey, from: objectForKey, resourceType: resourceType)
        } else if let objectForKeyCollection = currentValue as? [[String: Any]] {
            return objectForKeyCollection.map { getCustomObject(for: customKey, from: $0, resourceType: resourceType) }
        }
        
        return currentValue
    }
    
    private func getCustomObject(for key: String, from objectsJson: [String: Any], resourceType: Resource.Type) -> CustomObject? {
        let objectType = resourceType.typesForKeys[key]
        return objectType?.init(objectJson: objectsJson)
    }

    private func setRelationships(on resource: Resource, with relationships: Any?) {
        guard let relationships = relationships as? [String: [String: Any]] else {
            return
        }

        relationships.forEach { (key, value) in
            set(relationships: value, for: key, on: resource)
        }
    }

    private func set(relationships: [String: Any], for key: String, on resource: Resource) {
        let relationshipObject = relationships.data
        let resourceType = type(of: resource)
        let customKey = resourceType.customKeys[key] ?? key

        if let baseResource = relationshipObject as? [String: Any] {
            let relationship = createRelationship(from: baseResource)
            setLinks(on: relationship, with: relationships)
            resource.setValueIfPossible(value: relationship, for: customKey)
        } else if let resourceCollection = relationshipObject as? [[String: Any]] {
            let relationships = resourceCollection.map(createRelationship).compactMap { $0 }
            resource.setValueIfPossible(value: relationships, for: customKey)
        }
    }

    private func createRelationship(from baseResource: [String: Any]) -> Resource? {
        guard let identifier = baseResource.id,
            let type = baseResource.type else {
                return nil
        }

        let classType = resourceMap?[type]
        return classType?.init(id: identifier)
    }

    private func setLinks(on resource: Resource?, with json: [String: Any]) {
        if let links = linksDeserializer.deserializeLinks(from: json) {
            resource?.links = links
        }
    }
    
    private func setMeta(on resource: Resource?, with json: [String: Any]) {
        if let meta = metaDeserializer.deserializeMeta(from: json) {
            resource?.meta = meta
        }
    }
}

private extension Resource {

    func setValueIfPossible(value: Any?, for key: String) {
        if responds(to: NSSelectorFromString(key)) {
            setValue(value, forKey: key)
        }
    }
}
