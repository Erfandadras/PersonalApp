//
//  HomeViewModel.swift
//  ErfanApp
//
//  Created by Erfan mac mini on 12/2/25.
//

import SwiftUI
import BaseModule
import ServiceModule

@MainActor
@Observable
final class HomeViewModel: BaseViewModel {
    // MARK: - Properties
    private let authService: FirebaseAuthService
    
    // MARK: - Init
    init(authService: FirebaseAuthService = .init()) {
        self.authService = authService
    }
    
    // MARK: - logic
    func logout() -> Bool {
        do {
            try authService.signOut()
            toast = .init(type: .success, message: "Logout successfully")
            return true
        } catch {
            Logger.log(.function, level: .error, error.localizedDescription)
            toast = .init(type: .error, message: "Failed to logout")
            return false
        }
    }
}
