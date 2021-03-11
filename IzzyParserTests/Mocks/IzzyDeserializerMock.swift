import Foundation
@testable import IzzyParser

class IzzyDeserializerMock: IzzyDeserializer {
    var didDeserializeSingle = false
    var didDeserializeCollection = false
    var didSetDebugMode = false
    
    override public var isDebugModeOn: Bool {
        didSet {
            didSetDebugMode = true
        }
    }
    
    override func deserialize<T>(_ data: Data) throws -> Document<T> where T: Resource {
        didDeserializeSingle = true
        return try Document(data: nil, errors: nil, meta: nil, jsonapi: nil, links: nil)
    }
    
    override func deserializeCollection<T>(_ data: Data) throws -> Document<[T]> where T: Resource {
        didDeserializeCollection = true
        return try Document(data: nil, errors: nil, meta: nil, jsonapi: nil, links: nil)
    }
}
