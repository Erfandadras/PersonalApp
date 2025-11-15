//
//  Injectable.swift
//  BaseModule
//
//  Created by Erfan mac mini on 11/15/25.
//

import Foundation

/// Protocol for services that can be registered in the container
public protocol Injectable {}

/// Lightweight dependency injection container
public final class DependencyContainer {
    public static let shared = DependencyContainer()
    
    private var services: [String: Any] = [:]
    
    private init() {}
    
    /// Register a service instance
    public func register<Service>(_ service: Service, for type: Service.Type) {
        let key = String(describing: type)
        services[key] = service
    }
    
    /// Resolve a service instance
    public func resolve<Service>(_ type: Service.Type) -> Service? {
        let key = String(describing: type)
        return services[key] as? Service
    }
    
    /// Force resolve - crashes if service not found (use during development)
    public func forceResolve<Service>(_ type: Service.Type) -> Service {
        guard let service = resolve(type) else {
            fatalError("❌ Service \(type) not registered in DependencyContainer")
        }
        return service
    }
    
    /// Clear all services (useful for testing)
    public func reset() {
        services.removeAll()
    }
}

/// Property wrapper for easy dependency injection
@propertyWrapper
public struct Injected<Service> {
    private let container: DependencyContainer
    
    public var wrappedValue: Service {
        container.forceResolve(Service.self)
    }
    
    public init(container: DependencyContainer = .shared) {
        self.container = container
    }
}
