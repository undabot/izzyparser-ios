public protocol Serializer {
    func serialize(resource: Resource) -> [String: Any]
    func serialize(_ resource: Resource, attributeKey: String, attributeValue: Any) -> [String: Any]
    func serialize(_ resource: Resource, relationshipKey: String, relationshipValue: Any) -> [String: Any]
    func serialize(resourceCollection: [Resource]) -> [String: Any]
}
