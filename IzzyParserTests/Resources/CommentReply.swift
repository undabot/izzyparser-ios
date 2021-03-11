import Foundation
@testable import IzzyParser

@objcMembers class CommentReply: NSObject, CodableCustomObject {
    var authorName: String?
    var contents: String?
}
