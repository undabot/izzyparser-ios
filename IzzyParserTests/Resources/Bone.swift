import Foundation

class Bone: NSObject {
    @objc var id: String
    @objc var name: String
    @objc var family: BoneFamily?
    @objc var similar: [Bone]?
    @objc var terminology: [String]?
    
    @objc var numericIdentifiers: [NSNumber] = {
        return [1, .null]
    }()
    
    @objc var stringIdentifiers: [String] = {
        return .null
    }()
    
    init(id: String,
         name: String,
         family: BoneFamily? = nil,
         similar: [Bone]? = nil,
         terminology: [String]? = nil) {
        self.id = id
        self.name = name
        self.family = family
        self.similar = similar
        self.terminology = terminology
    }
}

class BoneFamily: NSObject {
    @objc var id: String
    
    init(id: String) {
        self.id = id
    }
}
