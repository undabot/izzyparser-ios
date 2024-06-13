import Foundation
import ObjectiveC.runtime

public class IzzyBuilder {
    
    private let singleSerializer = SingleResourceSerializer()
    
    private var dictionary: SingleResourceJSON?
    private var attributes = [String: Any]()
    private var relationships = [String: Any]()
    
    public init(resource: Resource) {
        dictionary = singleSerializer.parse(resource: resource)
        attributes = dictionary?.attributes ?? [:]
        relationships = dictionary?.relationships ?? [:]
    }
    
    public func attribute(_ name: String, value: Any?) -> Self {
        if let value = value {
            attributes.updateValue(value, forKey: name)
        }
        return self
    }
    
    public func relationship(_ name: String, value: Any?) -> Self {
        if let value = value {
            relationships.updateValue(value, forKey: name)
        }
        return self
    }
    
    public func serialize() -> [String: Any] {
        let resourceJson = SingleResourceJSON(data: dictionary?.data ?? [:],
                                              attributes: attributes,
                                              relationships: relationships)
        var document = [String: Any]()
        document.data = resourceJson.toDataDictionary()
        
        return document
    }
}
