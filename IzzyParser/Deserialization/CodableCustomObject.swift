public protocol CodableCustomObject: Codable, CustomObject {}

extension CodableCustomObject {
    public init?(objectJson: [String: Any]) {
        self.init(json: objectJson)
    }
}
