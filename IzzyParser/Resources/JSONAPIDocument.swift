import Foundation

public class Document<ResourceType: Any> {
    public var data: ResourceType?
    public var errors: [JSONAPIError]?
    public var meta: Meta?
    public var jsonapi: JSONApi?
    public var links: Links?
    
    public init(data: ResourceType?,
                errors: [JSONAPIError]?,
                meta: Meta?,
                jsonapi: JSONApi?,
                links: Links?) throws {
        
        if data != nil && errors != nil {
            throw IzzyError.invalidJSONAPIResponse
        }
        
        self.data = data
        self.errors = errors
        self.meta = meta
        self.jsonapi = jsonapi
        self.links = links
    }
}
