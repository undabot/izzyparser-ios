import Foundation

class SerializationValidator {
    
    func isObject(attributeValue: Any) -> Bool {
        if !(attributeValue is Int ||
            attributeValue is Int8 ||
            attributeValue is Int32 ||
            attributeValue is UInt ||
            attributeValue is UInt16 ||
            attributeValue is UInt32 ||
            attributeValue is Double ||
            attributeValue is Float ||
            attributeValue is Decimal ||
            attributeValue is Bool ||
            attributeValue is String ||
            attributeValue is NSNumber ||
            attributeValue is NSString) {
            return true
        }
        
        return false
    }
    
    func isNull(value: Any) -> Bool {
        if let value = value as? Nullable {
            return value.isNull
        } else if let value = value as? String {
            return value.isNull
        } else if let value = value as? NSNumber {
            return value.isNull
        } else if let value = value as? [String] {
            return value.isNull
        } else if let value = value as? [String: Any] {
            return value.isNull
        } else if let value = value as? [[String: Any]] {
            return value.isNull
        }
        
        return false
    }
    
    func isNil(attributeName: String, in object: AnyObject) -> Bool {
        return object.value(forKey: attributeName) == nil
    }
    
    func isResource(value: Any) -> Bool {
        return value is Resource
    }
    
    func isResourceCollection(_ value: Any) -> Bool {
        guard value as? [Resource] != nil
            else {
                return false
        }
        
        return true
    }
    
    func isNonObjectCollection(_ value: AnyObject) -> Bool {
        if isArrayOfPrimitives(value) ||
            isDictionary(value) ||
            isCollectionOfDictionaries(value) {
            return true
        }
        
        return false
    }
    
    func isArrayOfPrimitives(_ value: Any) -> Bool {
        guard let collection = value as? [AnyObject],
            let firstElement = collection.first,
            !isObject(attributeValue: firstElement) else {
                return false
        }
        
        return true
    }
    
    func isCollectionOfDictionaries(_ value: Any) -> Bool {
        guard value as? [[AnyHashable: Any]] != nil else {
                return false
        }
        
        return true
    }
    
    func isCollection(_ value: Any) -> Bool {
        return isArray(value) || isDictionary(value)
    }
    
    func isArray(_ value: Any) -> Bool {
        return value is NSArray
    }
    
    func isDictionary(_ value: Any) -> Bool {
        return value is NSDictionary
    }
}
