import Foundation
@testable import IzzyParser

@objcMembers class Tag: Resource {
    var title: String?

    override class var type: String {
        return "tags"
    }
}
