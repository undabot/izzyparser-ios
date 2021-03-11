import Foundation
@testable import IzzyParser

class Person: Resource {
    @objc var someBool: NSNumber?
    @objc var someIntAttribute: NSNumber?
    @objc var bones: [Bone]?
    
    override class var type: String {
        return "persons"
    }
    
    override public class var customKeys: [String: String] {
        return ["some_int_attribute": "someIntAttribute"]
    }
    
    init(id: String, someBool: NSNumber? = nil, someIntAttribute: NSNumber? = nil, bones: [Bone]? = nil) {
        self.someBool = someBool
        self.someIntAttribute = someIntAttribute
        self.bones = bones
        super.init(id: id)
    }
    
    required init(id: String) {
        super.init(id: id)
    }
}
