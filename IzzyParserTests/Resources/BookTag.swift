import Foundation
@testable import IzzyParser

class BookTag: Resource {
    @objc var desc: String?
    
    override class var type: String {
        return "tags"
    }
    
    override public class var customKeys: [String: String] {
        return ["description": "desc"]
    }
    
    init(id: String, description: String?) {
        self.desc = description
        super.init(id: id)
    }
    
    required init(id: String) {
        super.init(id: id)
    }
}
