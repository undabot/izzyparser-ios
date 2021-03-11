import Foundation

class ErrorsDeserializer {
    
    let linksDeserializer = LinksDeserializer()
    
    func deserializeErrors(from json: [String: Any]) throws -> [JSONAPIError]? {
        guard let errorsJSON = json.errors else {
            return nil
        }

        return errorsJSON.map { (errorDictionary) -> JSONAPIError in
            var jsonAPIError = JSONAPIError(params: errorDictionary)
            jsonAPIError.links = linksDeserializer.deserializeLinks(from: errorDictionary)
            return jsonAPIError
        }
    }
}
