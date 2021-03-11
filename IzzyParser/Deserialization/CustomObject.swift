import Foundation

public protocol CustomObject: NSObjectProtocol {
    init?(objectJson: [String: Any])
}
