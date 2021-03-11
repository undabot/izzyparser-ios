import Foundation

public class IzzyDeserializer: Deserializer {

    var resourceDeserializer = ResourceDeserializer()
    var linksDeserializer = LinksDeserializer()
    var metaDeserializer = MetaDeserializer()
    var jsonApiDeserializer = JSONApiDeserializer()
    var errorsDeserializer = ErrorsDeserializer()
    public var isDebugModeOn: Bool {
        didSet {
            resourceDeserializer.isDebugModeOn = isDebugModeOn
        }
    }
    
    init(isDebugModeOn: Bool = false) {
        self.isDebugModeOn = isDebugModeOn
    }
    
    /// Resource map contains all resource class types that should be deserialized from JSON
    /// E.g.: JSON contains `article` with relationships `author` and `comment`
    /// Than resource map should be:
    ///  [Article.type: Article.self, Author.type: Author.self, Comment.type: Comment.self]
    public func registerResources(resourceMap: [String: Resource.Type]) {
        resourceDeserializer.resourceMap = resourceMap
    }

    /**
     Method for deserializing single resource.
     
     - parameter data: Data containing JSONAPI document
     - returns: Document object with deserialized resource
     - throws: error if JSONSerialization fails or JSONAPI specification is not satisfied
     
     */
    public func deserialize<T: Resource>(_ data: Data) throws -> Document<T> {
        guard !data.isEmpty else {
            return try Document(data: nil, errors: nil, meta: nil, jsonapi: nil, links: nil)
        }

        guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
            throw IzzyError.invalidJSONFormat
        }

        return try deserialize(from: json)
    }

    /**
     Method for deserializing resource collection.
     
     - parameter data: Data containing JSONAPI document
     - returns: Document object with deserialized resource collection
     - throws: error if JSONSerialization fails or JSONAPI specification is not satisfied
     
     */
    public func deserializeCollection<T: Resource>(_ data: Data) throws -> Document<[T]> {
        guard !data.isEmpty else {
            return try Document(data: nil, errors: nil, meta: nil, jsonapi: nil, links: nil)
        }

        guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
            throw IzzyError.invalidJSONFormat
        }

        return try deserializeCollection(from: json)
    }

    /**
     Method for deserializing single resource.
     
     - parameter json: Dictionary containing JSONAPI document
     - returns: Document object with deserialized resource
     - throws: error if JSONAPI specification is not satisfied
     
     */
    public func deserialize<T: Resource>(from json: [String: Any]) throws -> Document<T> {
        let links = linksDeserializer.deserializeLinks(from: json)
        let meta = metaDeserializer.deserializeMeta(from: json)
        let jsonapi = jsonApiDeserializer.deserializeJSONApi(from: json)
        let errors = try errorsDeserializer.deserializeErrors(from: json)
        let resource: T? = try deserializeResource(from: json)

        try linkIncludedResources(with: [resource], from: json)

        return try Document(data: resource, errors: errors, meta: meta, jsonapi: jsonapi, links: links)
    }

    /**
     Method for deserializing resource collection.
     
     - parameter json: Dictionary containing JSONAPI document
     - returns: Document object with deserialized resource collection
     - throws: error if JSONAPI specification is not satisfied
     
     */
    public func deserializeCollection<T: Resource>(from json: [String: Any]) throws -> Document<[T]> {
        let links = linksDeserializer.deserializeLinks(from: json)
        let meta = metaDeserializer.deserializeMeta(from: json)
        let jsonapi = jsonApiDeserializer.deserializeJSONApi(from: json)
        let errors = try errorsDeserializer.deserializeErrors(from: json)
        let resources: [T]? = try deserializeResourceCollection(from: json)
        
        try linkIncludedResources(with: resources, from: json)

        return try Document(data: resources, errors: errors, meta: meta, jsonapi: jsonapi, links: links)
    }

    private func deserializeResource<T: Resource>(from json: [String: Any]?) throws -> T? {
        guard let dataJSONDictionary = json?.data as? [String: Any] else {
            return nil
        }

        return try resourceDeserializer.deserializeResource(from: dataJSONDictionary) as? T
    }

    private func deserializeResourceCollection<T: Resource>(from json: [String: Any]?) throws -> [T]? {
        guard let dataJSONArray = json?.data as? [[String: Any]] else {
            return nil
        }

        return try dataJSONArray.compactMap(resourceDeserializer.deserializeResource)
    }

    private func linkIncludedResources(with resources: [Resource?]?, from json: [String: Any]) throws {
        guard let resources = resources else {
            return
        }

        var resourcePool = try deserializeIncludedResources(from: json)
        resourcePool?.append(contentsOf: resources.compactMap { $0 })
        resourcePool?.linkResources()
    }
    
    private func deserializeIncludedResources(from json: [String: Any]?) throws -> [Resource]? {
        guard let included = json?.included else {
            return nil
        }
        
        return try included.compactMap(resourceDeserializer.deserializeResource)
    }
}
