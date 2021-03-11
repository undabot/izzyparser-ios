import Foundation

protocol Nullable {
    var isNull: Bool { get }
}

private let nullString: String = UUID().uuidString
private let nullNumber: NSNumber = NSNumber(value: INT_MAX)
private let nullDictionary: [String: Any] = [.null: NSNull()]
private let nullStringArray: [String] = [.null]
private let nullNumberArray: [NSNumber] = [.null]
private let nullDictionaryArray: [[String: Any]] = [.null]

extension NSNumber: Nullable {
    var isNull: Bool {
        return self.isEqual(nullNumber)
    }
    
    public static var null: NSNumber {
        return nullNumber
    }
}

extension String: Nullable {
    var isNull: Bool {
        return self == nullString
    }
    
    public static var null: String {
        return nullString
    }
}

public extension Array where Element == String {
    var isNull: Bool {
        return self.first == .null
    }
    
    static var null: [Element] {
        return nullStringArray
    }
}

public extension Dictionary where Key == String, Value: Any {
    static var null: [String: Any] {
        return nullDictionary
    }
    
    var isNull: Bool {
        return self[.null] is NSNull
    }
}

public extension Array where Element == [String: Any] {
    static var null: [Element] {
        return nullDictionaryArray
    }
    
    var isNull: Bool {
        return self.first?.isNull ?? false
    }
}

public extension Array where Element == NSNumber {
    static var null: [Element] {
        return nullNumberArray
    }
}
