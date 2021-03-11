public protocol Deserializer {
    func registerResources(resourceMap: [String: Resource.Type])
    func deserialize<T: Resource>(_ data: Data) throws -> Document<T>
    func deserializeCollection<T: Resource>(_ data: Data) throws -> Document<[T]>
    func deserialize<T: Resource>(from json: [String: Any]) throws -> Document<T>
    func deserializeCollection<T: Resource>(from json: [String: Any]) throws -> Document<[T]>
    var isDebugModeOn: Bool { get set }
}
