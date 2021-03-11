struct SingleResourceJSON {
    let data: [String: Any]
    let attributes: [String: Any]
    let relationships: [String: Any]
    
    static let empty = SingleResourceJSON(data: [:], attributes: [:], relationships: [:])
}

extension SingleResourceJSON {
    
    func toDataDictionary() -> [String: Any] {
        var dictionary = self.data
        
        if !self.attributes.isEmpty {
            dictionary["attributes"] = self.attributes
        }
        
        if !self.relationships.isEmpty {
            dictionary["relationships"] = self.relationships
        }
        
        return dictionary
    }
}
