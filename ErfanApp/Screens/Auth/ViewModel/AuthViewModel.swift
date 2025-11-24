//
//  AuthViewModel.swift
//  ErfanApp
//
//  Created by Erfan mac mini on 11/24/25.
//

import SwiftUI
import AuthenticationServices
import Combine

// MARK: - Auth State
enum AuthState {
    case login
    case signUp
    case forgotPassword
}

// MARK: - Auth View Model
@MainActor
final class AuthViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var authState: AuthState = .login
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var fullName = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showError = false
    
    // MARK: - Validation
    var isValidEmail: Bool {
        // Basic email validation
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    var isValidPassword: Bool {
        // Password must be at least 6 characters
        return password.count >= 6
    }
    
    var isFormValid: Bool {
        switch authState {
        case .login:
            return isValidEmail && isValidPassword
        case .signUp:
            return isValidEmail && isValidPassword && !fullName.isEmpty && password == confirmPassword
        case .forgotPassword:
            return isValidEmail
        }
    }
    
    // MARK: - Actions
    func handlePrimaryAction() {
        guard isFormValid else {
            errorMessage = "Please check your input."
            showError = true
            return
        }
        
        isLoading = true
        
        // Simulate network delay
        Task {
            try? await Task.sleep(nanoseconds: 1_500_000_000)
            isLoading = false
            print("Action for \(authState) triggered with Email: \(email)")
            // TODO: Integrate actual API call here
        }
    }
    
    func switchState(to state: AuthState) {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
            self.authState = state
            self.errorMessage = nil
            self.showError = false
        }
    }
    
    // MARK: - Social Auth
    func handleAppleSignIn(result: Result<ASAuthorization, Error>) {
        switch result {
        case .success(let auth):
            switch auth.credential {
            case let appleIDCredential as ASAuthorizationAppleIDCredential:
                let userId = appleIDCredential.user
                let email = appleIDCredential.email
                let fullName = appleIDCredential.fullName
                print("Apple Sign In Success: \(userId), \(String(describing: email)), \(String(describing: fullName))")
                // TODO: Handle successful login
            case let passwordCredential as ASPasswordCredential:
                let username = passwordCredential.user
                let password = passwordCredential.password
                print("Apple Password Credential: \(username), \(password)")
                 // TODO: Handle existing password credential
            default:
                break
            }
        case .failure(let error):
            print("Apple Sign In Failed: \(error.localizedDescription)")
            errorMessage = error.localizedDescription
            showError = true
        }
    }
    
    func handleGoogleSignIn() {
        // Mock Google Sign In
        isLoading = true
        Task {
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            isLoading = false
            print("Google Sign In Triggered")
            // TODO: Implement Google Sign In SDK
        }
    }
    
    func handlePassKey() {
        // Mock PassKey
        print("PassKey Flow Triggered")
        // TODO: Implement PassKey using AuthenticationServices
    }
}
