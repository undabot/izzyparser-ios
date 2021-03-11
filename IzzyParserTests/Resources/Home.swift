import Foundation

@objcMembers class Home: NSObject {
    var id: Int
    var address: String
    
    init(id: Int, address: String) {
        self.id = id
        self.address = address
    }
}
