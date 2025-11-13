import Foundation

/// Base module providing foundational functionality for the app
public struct Base {
    public init() {}
    
    public func hello() -> String {
        return "Hello from Base module!"
    }
}

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

