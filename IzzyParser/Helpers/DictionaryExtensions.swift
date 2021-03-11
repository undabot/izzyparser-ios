import Foundation

extension Dictionary where Key == String, Value == Any {
    
    var id: String? {
        get {
            return self["id"] as? String
        }
        set {
            self["id"] = newValue
        }
    }
    
    var type: String? {
        get {
            return self["type"] as? String
        }
        set {
            self["type"] = newValue
        }
    }

    var attributes: [String: Any]? {
        get {
            return self["attributes"] as? [String: Any]
        }
        set {
            self["attributes"] = newValue
        }
    }

    var relationships: [String: Any]? {
        get {
            return self["relationships"] as? [String: [String: Any]]
        }
        set {
            self["relationships"] = newValue
        }
    }

    var data: Any? {
        get {
            return self["data"]
        }
        set {
            self["data"] = newValue
        }
    }
    
    var links: [String: Any]? {
        return self["links"] as? [String: Any]
    }
    
    var href: String? {
        return self["href"] as? String
    }
    
    var meta: Meta? {
        return self["meta"] as? Meta
    }
    
    var status: String? {
        return self["status"] as? String
    }
    
    var code: String? {
        return self["code"] as? String
    }
    
    var title: String? {
        return self["title"] as? String
    }
    
    var detail: String? {
        return self["detail"] as? String
    }

    var errors: [[String: Any]]? {
        return self["errors"] as? [[String: Any]]
    }

    var included: [[String: Any]]? {
        return self["included"] as? [[String: Any]]
    }
}

extension Dictionary where Key == String, Value == String {
    
    var reversed: [String: String] {
        var reverseDict = [String: String]()
        
        for (key, value) in self {
            reverseDict[value] = key
        }
        
        return reverseDict
    }
}
