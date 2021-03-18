import Foundation

extension Data {
    
    init(with filename: String, for object: AnyClass) throws {
        #if SWIFT_PACKAGE
        let path = Bundle.module.url(forResource: filename, withExtension: "json")!
        #else
        let bundle = Bundle(for: object)
        let path = bundle.url(forResource: filename, withExtension: "json")!
        #endif
        self = try Data(contentsOf: path)
    }
}

// JSON pretty print
extension Collection {
    
    public func toJson() -> String {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: [.prettyPrinted])
            guard let jsonString = String(data: jsonData, encoding: String.Encoding.utf8) else {
                print("Can't create string with data.")
                return "{}"
            }
            return jsonString
        } catch let error {
            print("Json serialization error: \(error)")
            return "{}"
        }
    }
}
