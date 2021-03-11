import Foundation

public enum IzzyError: Error {
    
    case invalidJSONFormat
    case invalidJSONAPIResponse
    case unregisteredResource(type: String)

    var description: String {
        switch self {
        case .invalidJSONFormat:
            return "Invalid JSON format."
        case .invalidJSONAPIResponse:
            return "JSON Api specification requirements not satisfied."
        case .unregisteredResource(let type):
            return "\(type) is not registered as a resource."
        }
    }
}
