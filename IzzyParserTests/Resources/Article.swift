import Foundation
@testable import IzzyParser

@objcMembers class Article: Resource {
    var title: String?
    var text: String?
    var author: Author?
    var tags: [Tag]?
    var comments: [Comment]?
    var customAttribute: FakeCustomAttribute?
    var anotherCustomAttribute: FakeAnotherCustomAttribute?
    var codableCustomAttribute: CodableCustomAttribute?
    
    override class var type: String {
        return "articles"
    }
    
    override public class var customKeys: [String: String] {
        return ["custom_attribute": "customAttribute"]
    }

    init(id: String, title: String? = nil, text: String? = nil, author: Author? = nil) {
        self.title = title
        self.text = text
        self.author = author
        super.init(id: id)
    }

    required init(id: String) {
        super.init(id: id)
    }
    
    override public class var typesForKeys: [String: CustomObject.Type] {
        return ["customAttribute": FakeCustomAttribute.self,
                "anotherCustomAttribute": FakeAnotherCustomAttribute.self,
                "codableCustomAttribute": CodableCustomAttribute.self]
    }
}

class FakeCustomAttribute: NSObject, CustomObject {
    var name: String?
    
    required init(objectJson: [String: Any]) {
        self.name = objectJson["name"] as? String
    }
}

class FakeAnotherCustomAttribute: NSObject, CustomObject {
    var anotherName: String?
    
    required init(objectJson: [String: Any]) {
        self.anotherName = objectJson["anotherName"] as? String
    }
}

class CodableCustomAttribute: NSObject, CodableCustomObject {
    var codableName: String?
}
