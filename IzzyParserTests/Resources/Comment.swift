import Foundation
@testable import IzzyParser

class Comment: Resource {
    @objc var title: String?
    @objc var author: Author?
    @objc var reviewer: Author?
    @objc var body: String?
    @objc var replies: [CommentReply]?
    
    override class var typesForKeys: [String: CustomObject.Type] {
        return ["replies": CommentReply.self]
    }
    
    override class var type: String {
        return "comments"
    }
}

class BrokenComment: Comment {
    override class var typesForKeys: [String: CustomObject.Type] {
        return [:]
    }
}
