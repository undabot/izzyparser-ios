import Foundation
@testable import IzzyParser

class Book: Resource {
    @objc var title: String?
    @objc var author: Person?
    @objc var home: Home?
    @objc var tags: [BookTag]?
    
    @objc var subtitle: String = {
        return "subtitle"
    }()
    
    @objc var chapters: [String] = {
        return ["1", "2", .null]
    }()
    
    @objc var subchapters: [[String: Any]] = {
        return [
            ["1": ["1.1", "1.2"]],
            ["2": ["2.1", "2.2"]],
            .null
        ]
    }()
    
    @objc var pages: [[String: Any]] = {
        return .null
    }()
    
    override class var type: String {
        return "books"
    }
    
    init(id: String, title: String? = nil, author: Person? = nil, home: Home? = nil, tags: [BookTag]? = nil) {
        self.title = title
        self.title = title
        self.author = author
        self.home = home
        self.tags = tags
        super.init(id: id)
    }
    
    required init(id: String) {
        super.init(id: id)
    }
}
