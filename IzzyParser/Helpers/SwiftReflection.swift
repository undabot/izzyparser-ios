import Foundation
import ObjectiveC.runtime

extension NSObject {
    
    var properties: [Property] {
        var propertiesInClassHierarchy = [(UInt32, UnsafeMutablePointer<objc_property_t>?)]()

        var selfPropertiesCount: UInt32 = 0
        let selfProperties = class_copyPropertyList(type(of: self), &selfPropertiesCount)
        propertiesInClassHierarchy.append((selfPropertiesCount, selfProperties))
        propertiesInClassHierarchy.append(contentsOf: superClassProperties())

        let propertyCount = propertiesInClassHierarchy.reduce(0) { $0 + Int($1.0) }
        guard propertyCount > 0 else { return [Property]() }
        var resourceProperties = [Property]()

        propertiesInClassHierarchy
            .filter { $0.0 > 0 }
            .forEach { (count, properties) in
                for index in 0 ..< Int(count) {
                    let property = properties![index]
                    resourceProperties.append(property)
                }
        }

        propertiesInClassHierarchy.forEach { free($0.1) }
        return resourceProperties
    }

    private func superClassProperties() -> [(UInt32, UnsafeMutablePointer<objc_property_t>?)] {
        guard self is Resource else {
            return []
        }
        
        var superclassProperties = [(UInt32, UnsafeMutablePointer<objc_property_t>?)]()

        var superclassType: AnyClass? = type(of: self).superclass()
        while superclassType != nil && superclassType != Resource.self {
            var superClassPropertiesCount: UInt32 = 0
            let superClassProperties = class_copyPropertyList(superclassType, &superClassPropertiesCount)
            superclassProperties.append((superClassPropertiesCount, superClassProperties))
            superclassType = superclassType?.superclass()
        }

        return superclassProperties
    }
}

extension Property {
    
    var name: String {
        return NSString(utf8String: property_getName(self)) as String? ?? ""
    }
}
