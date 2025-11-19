import Foundation

/// Base configuration protocol
public protocol BaseConfiguration {
    var appName: String { get }
    var version: String { get }
}

/// Default configuration implementation
public struct DefaultConfiguration: BaseConfiguration {
    public let appName: String
    public let version: String
    
    public init(appName: String = "ErfanApp", version: String = "1.0.0") {
        self.appName = appName
        self.version = version
    }
}

