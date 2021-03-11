import Foundation
@testable import IzzyParser

@objcMembers class RelatedArticle: Article {
    
    var relatedHeadline: String?
    
    override class var type: String {
        return "related_articles"
    }
    
    init(relatedHeadline: String?) {
        self.relatedHeadline = relatedHeadline
        super.init(id: "23")
    }
    
    override public class var customKeys: [String: String] {
        var superClassCustomKeys = super.customKeys
        superClassCustomKeys["related_headline"] = "relatedHeadline"
        return superClassCustomKeys
    }
    
    required init(id: String) {
        relatedHeadline = nil
        super.init(id: id)
    }
}
