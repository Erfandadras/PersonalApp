import Foundation
import FirebaseAuth
import BaseModule

/// Firebase Authentication Service
public class FirebaseAuthService {
    // MARK: - properties
    private let auth: Auth
    
    // MARK: - init
    public init(auth: Auth = FirebaseAuth.Auth.auth()) {
        self.auth = auth
    }
    
    // MARK: - Sign Up
    /// Sign up with email and password
    public func signUp(email: String, password: String) async throws -> User {
        let result = try await auth.createUser(withEmail: email, password: password)
        return result.user
    }
    
    /// Sign in with email and password
    public func signIn(email: String, password: String) async throws -> User {
        let result = try await auth.signIn(withEmail: email, password: password)
        return result.user
    }
    
    /// Sign in anonymously
    public func signInAnonymously() async throws -> User {
        let result = try await auth.signInAnonymously()
        return result.user
    }
    
    // MARK: - PassKey Authentication
    /// Sign in with PassKey credential
    /// Note: This creates/signs in a user using the PassKey credential ID as a unique identifier
    public func signInWithPassKey(credentialID: String, userName: String?) async throws -> User {
        // For PassKey, we'll use anonymous authentication and then link it with the credential
        // In a production app, you would validate the PassKey credential with your backend
        // and receive a custom token to sign in with Firebase
        
        // Check if user already exists with this credential ID (stored in user metadata)
        // For now, we'll sign in anonymously and set display name
        let result = try await auth.signInAnonymously()
        
        if let userName = userName, !userName.isEmpty {
            let changeRequest = result.user.createProfileChangeRequest()
            changeRequest.displayName = userName
            try await changeRequest.commitChanges()
        }
        
        return result.user
    }
    
    /// Register user with PassKey
    /// This method combines PassKey registration with Firebase user creation
    public func registerWithPassKey(userName: String, credentialID: String) async throws -> User {
        // In production, you would:
        // 1. Send the PassKey credential to your backend
        // 2. Backend validates the credential
        // 3. Backend creates a custom token
        // 4. Use the custom token to sign in to Firebase
        
        // For now, we'll create an anonymous user and set the display name
        let result = try await auth.signInAnonymously()
        
        let changeRequest = result.user.createProfileChangeRequest()
        changeRequest.displayName = userName
        try await changeRequest.commitChanges()
        
        return result.user
    }
    
    // MARK: - Sign Out
    /// Sign out current user
    public func signOut() throws {
        try auth.signOut()
    }
    
    // MARK: - Password Reset
    /// Send password reset email
    public func sendPasswordReset(email: String) async throws {
        try await auth.sendPasswordReset(withEmail: email)
    }
    
    // MARK: - User Management
    /// Get current user
    public var currentUser: User? {
        return auth.currentUser
    }
    
    /// Check if user is authenticated
    public var isAuthenticated: Bool {
        return currentUser != nil
    }
    
    /// Get current user info
    public var currentUserEmail: String? {
        return currentUser?.email
    }
    
    public var currentUserDisplayName: String? {
        return currentUser?.displayName
    }
    
    /// Update user email
    public func updateEmail(to newEmail: String) async throws {
        guard let user = currentUser else {
            throw AuthError.noUser
        }
        try await user.updateEmail(to: newEmail)
    }
    
    /// Update user password
    public func updatePassword(to newPassword: String) async throws {
        guard let user = currentUser else {
            throw AuthError.noUser
        }
        try await user.updatePassword(to: newPassword)
    }
    
    /// Delete current user account
    public func deleteAccount() async throws {
        guard let user = currentUser else {
            throw AuthError.noUser
        }
        try await user.delete()
    }
    
    // MARK: - User Profile
    
    /// Update user display name
    public func updateDisplayName(to displayName: String) async throws {
        guard let user = currentUser else {
            throw AuthError.noUser
        }
        let changeRequest = user.createProfileChangeRequest()
        changeRequest.displayName = displayName
        try await changeRequest.commitChanges()
    }
    
    /// Update user photo URL
    public func updatePhotoURL(to photoURL: URL) async throws {
        guard let user = currentUser else {
            throw AuthError.noUser
        }
        let changeRequest = user.createProfileChangeRequest()
        changeRequest.photoURL = photoURL
        try await changeRequest.commitChanges()
    }
}

// MARK: - Auth Errors

public enum AuthError: LocalizedError {
    case noUser
    case invalidCredentials
    case weakPassword
    case emailAlreadyInUse
    case unknown(Error)
    
    public var errorDescription: String? {
        switch self {
        case .noUser:
            return "No user is currently signed in"
        case .invalidCredentials:
            return "Invalid email or password"
        case .weakPassword:
            return "Password is too weak"
        case .emailAlreadyInUse:
            return "Email is already in use"
        case .unknown(let error):
            return error.localizedDescription
        }
    }
}

