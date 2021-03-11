import Foundation

class SpecialBook: Book {
    
    @objc let specialTitle: String?
    @objc let specialAuthor: Person?
    
    init(specialTitle: String?, specialAuthor: Person?, author: Person?) {
        self.specialTitle = specialTitle
        self.specialAuthor = specialAuthor
        super.init(id: "24", title: "Special book", author: author, home: Home(id: 2, address: "special"))
    }
    
    required init(id: String) {
        specialTitle = nil
        specialAuthor = nil
        super.init(id: id)
    }
    
    override public class var customKeys: [String: String] {
        return ["special_author": "specialAuthor",
                "special_title": "specialTitle"]
    }
}
