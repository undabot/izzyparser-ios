import Foundation

extension Encodable {
    public func json() -> [String: Any]? {
        do {
            let data = try JSONEncoder().encode(self)
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        } catch {
            return nil
        }
    }
}

extension Decodable {
    public init?(json: [String: Any]) {
        guard let data = try? JSONSerialization.data(withJSONObject: json, options: []),
            let object = try? JSONDecoder().decode(Self.self, from: data) else {
                return nil
        }
        self = object
    }
}
