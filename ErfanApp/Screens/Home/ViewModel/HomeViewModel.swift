//
//  HomeViewModel.swift
//  ErfanApp
//
//  Created by Erfan mac mini on 12/2/25.
//

import Combine
import BaseModule
import ServiceModule
internal import FirebaseAuth

final class HomeViewModel: BaseViewModel {
    // MARK: - Properties
    private let authService: FirebaseAuthService
    private let introductionService: UserIntroductionExsistenceChecker
    
    // MARK: - Init
    init(
        introductionService: UserIntroductionExsistenceChecker = IntroductionService(),
        authService: FirebaseAuthService = .init()
    ) {
            self.authService = authService
            self.introductionService = introductionService
    }
    
    // MARK: - logic
    @MainActor
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
    
    func userHasCompletedIntroduction() async -> Bool {
        do {
            return try await introductionService.hasData(userId: authService.currentUser?.uid ?? "")
        } catch {
            Logger.log(.function, level: .error, error.localizedDescription)
            return false
        }
    }
}
