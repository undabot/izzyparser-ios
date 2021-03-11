import Foundation
@testable import IzzyParser

class IzzySerializerMock: IzzySerializer {
    var didSerializeSingle = false
    var didSerializeCollection = false
    var didSerializeSingleWithCustomAttribute = false
    var didSerializeSingleWithCustomRelationship = false
    
    override func serialize(resource: Resource) -> [String: Any] {
        didSerializeSingle = true
        return [:]
    }
    
    override func serialize(resourceCollection: [Resource]) -> [String: Any] {
        didSerializeCollection = true
        return [:]
    }
    
    override func serialize(_ resource: Resource, attributeKey: String, attributeValue: Any) -> [String: Any] {
        didSerializeSingleWithCustomAttribute = true
        return [:]
    }
    
    override func serialize(_ resource: Resource, relationshipKey: String, relationshipValue: Any) -> [String: Any] {
        didSerializeSingleWithCustomRelationship = true
        return [:]
    }
}
