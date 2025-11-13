import Foundation
import BaseModule
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

// MARK: - Firebase Services Re-export
// These make Firebase services available to anyone importing Service module

/// Service module providing service layer functionality
public struct Service {
    private let configuration: BaseConfiguration
    
    public init(configuration: BaseConfiguration = DefaultConfiguration()) {
        self.configuration = configuration
    }
    
    public func getAppInfo() -> String {
        return "App: \(configuration.appName), Version: \(configuration.version)"
    }
    
    public func hello() -> String {
        return "Hello from Service module with Firebase!"
    }
}

/// Service protocol for dependency injection
public protocol ServiceProtocol {
    func fetchData() async throws -> Data
}

/// Example service implementation
public class DataService: ServiceProtocol {
    public init() {}
    
    public func fetchData() async throws -> Data {
        // Placeholder implementation
        return Data()
    }
}

// MARK: - Firebase Service Factory

/// Factory for creating Firebase service instances
public struct FirebaseServiceFactory {
    
    /// Get Firebase Manager instance
    public static var manager: FirebaseManager {
        return FirebaseManager.shared
    }
    
    /// Create Auth Service instance
    public static func createAuthService() -> FirebaseAuthService {
        return FirebaseAuthService()
    }
    
    /// Create Firestore Service instance
    public static func createFirestoreService() -> FirestoreService {
        return FirestoreService()
    }
    
    /// Create Storage Service instance
    public static func createStorageService() -> FirebaseStorageService {
        return FirebaseStorageService()
    }
}

