import Foundation
@testable import IzzyParser

@objcMembers class Reply: Resource {
    
    var replyAuthor: Author?
    
    override class var type: String {
        return "reply"
    }
    
    override public class var customKeys: [String: String] {
        return ["author": "replyAuthor"]
    }
}
