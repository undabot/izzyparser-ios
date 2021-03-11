import Foundation

extension Resource {
    
    struct Identity: Equatable, Hashable {

        let id: String
        let type: String
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(id.hashValue ^ type.hashValue)
        }

        static func == (lhs: Identity, rhs: Identity) -> Bool {
            return lhs.id == rhs.id && lhs.type == rhs.type
        }
        
        func toDataDictionary() -> [String: Any] {
            var dataDictionary = [String: Any]()
            dataDictionary.id = self.id
            dataDictionary.type = self.type
            
            var relationshipDictionary = [String: Any]()
            relationshipDictionary.data = dataDictionary
            
            return relationshipDictionary
        }
    }
}

extension Resource {
    var identity: Identity {
        return Identity(id: id, type: Swift.type(of: self).type)
    }
}
