import Foundation
@testable import IzzyParser

class Post: Resource {
    @objc var comments: [Comment]?
    @objc var author: Author?

    override class var type: String {
        return "posts"
    }
}
