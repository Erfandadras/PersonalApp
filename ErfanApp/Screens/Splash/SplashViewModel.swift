//
//  SplashViewModel.swift
//  ErfanApp
//
//  Created by Erfan mac mini on 11/26/25.
//

import SwiftUI
import Combine
import BaseModule
import ServiceModule


// MARK: - Splash View Model
@MainActor
@Observable
final class SplashViewModel: BaseViewModel {
    
    // MARK: - Properties
    var isCheckingAuth = true
    var animationCompleted: Bool = false {
        didSet {
            checkFlow()
        }
    }
    var appFlow: AppFlow = .splash
    private let authService: FirebaseAuthService
    
    // MARK: - Init
    init(authService: FirebaseAuthService = .init()) {
        self.authService = authService
    }
    
    // MARK: - Auth Status Check
    
    /// Check user authentication status
    func checkAuthStatus() {
        isCheckingAuth = true
        
        Task {
            // Check if user is authenticated
            if authService.isAuthenticated {
                Logger.log(.function, level: .info, "User is authenticated", currentUserEmail ?? "Unknown")
            } else {
                Logger.log(.function, level: .info, "User is not authenticated")
            }
            
            isCheckingAuth = false
            checkFlow()
        }
    }
    
    func checkFlow() {
        if !isCheckingAuth && animationCompleted {
            if authService.isAuthenticated {
                appFlow = .home
            } else {
                appFlow = .login
            }
        }
    }
    /// Get current user info
    var currentUserEmail: String? {
        return authService.currentUserEmail
    }
    
    var currentUserDisplayName: String? {
        return authService.currentUserDisplayName
    }
    
    var isUserAuthenticated: Bool {
        return authService.isAuthenticated
    }
}
