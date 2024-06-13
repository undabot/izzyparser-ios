import Foundation

@objc open class Resource: NSObject {
    
    @objc public var id: String
    @objc public var links: Links?
    @objc public var meta: Meta?
    
    open class var type: String {
        fatalError("Resource type must be overriden")
    }
    
    open class var typesForKeys: [String: CustomObject.Type] {
        return [:]
    }
    
    open class var customKeys: [String: String] {
        return [:]
    }
    
    public required init(id: String) {
        self.id = id
        super.init()
    }
}

@objc protocol ResourceSerialization {
    
    /// Serializes the resource. By default calls `Izzy().serialize(resource: self)`.
    /// - Can be overridden to serialize complex objects with multiple non-objc optional properties such as `Int?`, `Double?`, etc.
    /// - Returns: Serialized object.
    func serialized() -> [String: Any]
}

extension Resource: ResourceSerialization {
    
    @objc open func serialized() -> [String: Any] {
        return Izzy().serialize(resource: self)
    }
}
