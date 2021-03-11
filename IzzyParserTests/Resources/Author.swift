import Foundation
@testable import IzzyParser

class Author: Resource {
    @objc var comment: Comment?
    @objc var firstName: String?
    @objc var lastName: String?
    @objc var age: NSNumber?
    @objc var twitter: String?
    @objc var customAttribute: String?
    @objc var isMarried: NSNumber?
    @objc var luckyNumbers: [NSNumber]?
    @objc var luckyNames: [String]?
    @objc var luckyKeyValuePairs: [[String: Int]]?
    @objc var favoriteKeyValue: [String: Int]?
    @objc var nickname: String?

    override class var type: String {
        return "people"
    }

    override public class var customKeys: [String: String] {
        return ["first_name": "firstName"]
    }
}
