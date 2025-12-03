//
//  AuthViewModel.swift
//  ErfanApp
//
//  Created by Erfan mac mini on 11/24/25.
//

import UIKit
import AuthenticationServices
import Combine
import BaseModule
import ServiceModule
internal import FirebaseAuth

// MARK: - Auth State
enum AuthState {
    case login
    case signUp
    case forgotPassword
}

// MARK: - Auth View Model
@MainActor
@Observable
final class AuthViewModel: BaseViewModel {
    
    // MARK: - Published Properties
    var authState: AuthState = .login
    var dataModel = AuthModel()
    private let authService: FirebaseAuthService = .init()
    
    // MARK: - Actions
    func switchState(to state: AuthState) {
        self.dataModel.signInLoading = false
        self.dataModel.registerLoading = false
        self.authState = state
    }
}

// MARK: - login logic
extension AuthViewModel {
    func login() {
        self.dataModel.signInLoading = true
        guard dataModel.loginFormValidation else {
            updateState(state: .failure(error: CustomError(description: "Validation Error")))
            self.dataModel.signInLoading = false
            return
        }
        
        Task {
            do {
                let user = try await authService.signIn(email: dataModel.email, password: dataModel.password)
                self.dataModel.signInLoading = false
                self.setupToast(toast: .init(type: .success, message: "Signed in successfully", duration: 1))
                waitMainThread(after: 1.2) {
                    self.dataModel.user = .init(name: user.displayName ?? "Unknown", email: user.email ?? "Not Provided")
                }
                
            } catch {
                self.dataModel.signInLoading = false
                self.setupToast(toast: .init(type: .error,
                                             message: error.localizedDescription))
            }
        }
    }
    
    func handlePassKey() {
        // Check if PassKey is available
        guard PassKeyService.isPassKeyAvailable else {
            setupToast(toast: .init(type: .error, message: "PassKey is not available on this device"))
            return
        }
        
        Task {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let window = windowScene.windows.first else {
                setupToast(toast: .init(type: .error, message: "Unable to present PassKey"))
                return
            }
            
            self.dataModel.signInLoading = true
            let passKeyService = PassKeyService()
            
            // Try to sign in first
            do {
                let credential = try await passKeyService.signInWithPassKey(anchor: window)
                
                // Sign in to Firebase with PassKey credential
                let credentialIDString = credential.credentialID.base64EncodedString()
                let user = try await authService.signInWithPassKey(
                    credentialID: credentialIDString,
                    userName: nil
                )
                
                self.dataModel.signInLoading = false
                self.setupToast(toast: .init(type: .success, message: "Signed in with PassKey", duration: 1))
                waitMainThread(after: 1.2) {
                    self.dataModel.user = .init(
                        name: user.displayName ?? "PassKey User",
                        email: user.email ?? "Not Provided"
                    )
                }
                
            } catch PassKeyError.userCanceled {
                self.dataModel.signInLoading = false
                Logger.log(.function, level: .info, "PassKey canceled by user")
            } catch {
                // If sign in fails, offer to register
                Logger.log(.function, level: .info, "PassKey sign in failed, attempting registration")
                
                // Show alert to register
                self.dataModel.signInLoading = false
                self.dataModel.showPassKeyRegistration = true
            }
        }
    }
}

// MARK: - forget password
extension AuthViewModel {
    func forgetPassword() {
        
    }
}
// MARK: - register action
extension AuthViewModel {
    func registerPassKey(userName: String) {
        Task {
            do {
                guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                      let window = windowScene.windows.first else {
                    setupToast(toast: .init(type: .error, message: "Unable to present PassKey"))
                    return
                }
                
                self.dataModel.registerLoading = true
                let passKeyService = PassKeyService()
                
                // Generate a unique user ID
                let userID = UUID().uuidString
                
                // Register new PassKey
                let credential = try await passKeyService.registerPassKey(
                    userName: userName,
                    userID: userID,
                    anchor: window
                )
                
                // Register with Firebase
                let credentialIDString = credential.credentialID.base64EncodedString()
                Logger.log(.function, level: .info, credentialIDString, credential)
                let user = try await authService.registerWithPassKey(
                    userName: userName,
                    credentialID: credentialIDString
                )
                
                self.dataModel.registerLoading = false
                self.dataModel.showPassKeyRegistration = false
                self.setupToast(toast: .init(type: .success, message: "Welcome \(userName)"))
                
                self.dataModel.user = .init(
                    name: user.displayName ?? userName,
                    email: user.email ?? "Not Provided"
                )
                
            } catch PassKeyError.userCanceled {
                self.dataModel.registerLoading = false
                Logger.log(.function, level: .info, "PassKey registration canceled by user")
            } catch {
                self.dataModel.registerLoading = false
                Logger.log(.function, level: .error, "PassKey registration error", error.localizedDescription)
                setupToast(toast: .init(type: .error, message: error.localizedDescription))
            }
        }
    }
    
    func register() {
        guard dataModel.validateRegister() else {
            setupToast(toast: .init(type: .error, message: "Check your input"))
            return
        }
        self.dataModel.registerLoading = true
        Task {
            do {
                let user = try await authService.signUp(email: dataModel.email,
                                                        password: dataModel.password)
                try await authService.updateDisplayName(to: dataModel.fullName)
                self.dataModel.registerLoading = false
                self.dataModel.user = .init(name: user.displayName ?? "Unknown", email: user.email ?? "Not Provided")
                setupToast(toast: .init(type: .success, message: "Welcome \(dataModel.fullName)"))
            } catch {
                Logger.log(.function, level: .error, error.localizedDescription)
                self.dataModel.registerLoading = false
                self.setupToast(toast: .init(type: .error, message: "Something went wrong"))
            }
        }
    }
}
// MARK: - mutual signIn/login
extension AuthViewModel {
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
            Logger.log(.function, level: .error, "Apple Sign In Failed", error.localizedDescription)
            updateState(state: .failure(error: error))
        }
    }
    
    func handleGoogleSignIn() {
        // Mock Google Sign In
        updateState(state: .setLoading(value: true))
        Task {
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            updateState(state: .setLoading(value: false))
            print("Google Sign In Triggered")
            // TODO: Implement Google Sign In SDK
        }
    }
}
