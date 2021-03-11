import Foundation

public struct JSONAPIError {
    public let id: String?
    public var links: Links?
    public let status: String?
    public let code: String?
    public let title: String?
    public let detail: String?
    public let source: ErrorSource?
    public let meta: Meta?
    
    public init(params: [String: Any]) {
        self.id = params.id
        self.status = params.status
        self.code = params.code
        self.title = params.title
        self.detail = params.detail
        self.meta = params.meta
        self.source =  ErrorSource(params: params["source"] as? [String: Any])
    }
}

public struct ErrorSource {
    public let pointer: String?
    public let parameter: String?
    
    init(params: [String: Any]?) {
        self.pointer = params?["pointer"] as? String
        self.parameter = params?["parameter"] as? String
    }
}
