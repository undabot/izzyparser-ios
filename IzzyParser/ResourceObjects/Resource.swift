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
