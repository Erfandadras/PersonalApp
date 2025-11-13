import Foundation
import FirebaseAuth
import BaseModule

/// Firebase Authentication Service
public class FirebaseAuthService {
    private let auth: Auth
    
    public init(auth: Auth = FirebaseManager.shared.auth) {
        self.auth = auth
    }
    
    // MARK: - Sign Up
    
    /// Sign up with email and password
    public func signUp(email: String, password: String) async throws -> User {
        let result = try await auth.createUser(withEmail: email, password: password)
        return result.user
    }
    
    // MARK: - Sign In
    
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

