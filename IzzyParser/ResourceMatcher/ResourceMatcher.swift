import Foundation

typealias Resources = [Resource.Identity: Resource]
typealias Property = objc_property_t

extension Array where Element: Resource {

    func linkResources() {
        let resourceDictionary = reduce(into: Resources()) {
            $0[$1.identity] = $1
        }

        resourceDictionary.values.forEach { resource in
            linkProperties(of: resource, with: resourceDictionary)
        }
    }

    private func linkProperties(of resource: Resource, with resources: Resources) {
        resource.properties.forEach { property in
            link(property: property, of: resource, with: resources)
        }
    }
 
    private func link(property: Property, of resource: Resource, with resources: Resources) {
        let value = resource.value(forKey: property.name)

        if let resourceCollection = value as? [Resource] {
            resource.link(property: property, with: resourceCollection, from: resources)
        } else if let value = value as? Resource {
            resource.link(property: property, with: value, from: resources)
        }
    }
}

private extension Resource {

    func link(property: Property, with resourceCollection: [Resource], from resources: Resources) {
        let linkedCollection = resourceCollection.map { resources[$0.identity] ?? $0 }
        set(relationship: property.name, with: linkedCollection)
    }

    func link(property: Property, with resource: Resource, from resources: Resources) {
        set(relationship: property.name, with: resources[resource.identity])
    }

    private func set(relationship name: String, with resource: Resource?) {
        guard let resource = resource else {
            return
        }

        setValue(resource, forKey: name)
    }

    private func set(relationship name: String, with resources: [Resource]) {
        setValue(resources, forKey: name)
    }
}
