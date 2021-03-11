import Foundation

class LinksDeserializer {
    
    func deserializeLinks(from json: [String: Any]) -> Links? {
        guard let linksJSONDictionary = json.links else {
            return nil
        }
        
        let first = deserializeLink(from: linksJSONDictionary["first"])
        let last = deserializeLink(from: linksJSONDictionary["last"])
        let prev = deserializeLink(from: linksJSONDictionary["prev"])
        let next = deserializeLink(from: linksJSONDictionary["next"])
        let related = deserializeLink(from: linksJSONDictionary["related"])
        let `self` = deserializeLink(from: linksJSONDictionary["self"])
        
        return Links(first: first,
                      last: last,
                      prev: prev,
                      next: next,
                      related: related,
                      selfLink: `self`)
    }
    
    private func deserializeLink(from linkObject: Any?) -> Link? {
        var link: Link?
        
        if let linkDictionary = linkObject as? [String: Any] {
            link = Link(url: linkDictionary.href, meta: linkDictionary.meta)
        } else if let linkUrl = linkObject as? String {
            link = Link(url: linkUrl, meta: nil)
        }
        
        return link
    }
}

@objc public class Links: NSObject {
    public let first: Link?
    public let last: Link?
    public let prev: Link?
    public let next: Link?
    public let related: Link?
    public let `self`: Link?
    
    init(first: Link?, last: Link?, prev: Link?, next: Link?, related: Link?, selfLink: Link?) {
        self.first = first
        self.last = last
        self.prev = prev
        self.next = next
        self.related = related
        self.`self` = selfLink
    }
}
