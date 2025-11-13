import Foundation
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import BaseModule

/// Main Firebase configuration and management
public class FirebaseManager {
    public static let shared = FirebaseManager()
    
    private var isConfigured = false
    
    private init() {}
    
    /// Configure Firebase with the app
    public func configure() {
        guard !isConfigured else {
            print("Firebase already configured")
            return
        }
        
        FirebaseApp.configure()
        isConfigured = true
        print("✅ Firebase configured successfully")
    }
    
    /// Get Firebase Auth instance
    public var auth: Auth {
        return Auth.auth()
    }
    
    /// Get Firestore instance
    public var firestore: Firestore {
        return Firestore.firestore()
    }
    
    /// Get Firebase Storage instance
    public var storage: Storage {
        return Storage.storage()
    }
    
    /// Check if user is authenticated
    public var isAuthenticated: Bool {
        return auth.currentUser != nil
    }
    
    /// Get current user
    public var currentUser: User? {
        return auth.currentUser
    }
}

