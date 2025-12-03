//
//  CoreDependence.swift
//  BaseModule
//
//  Created by Erfan mac mini on 11/15/25.
//

import UIKit

public class CoreDependence: DependenceProviders {
    // MARK: - properties
    private let container = DependencyContainer.shared
    
    // MARK: - init
    public init() {}

    // MARK: - logic
    public func execute() {
        let userManager = UserManager()
        container.register(userManager, for: UserManager.self)
        
        let themeManager = ThemeManager(userManager: userManager)
        container.register(themeManager, for: ThemeManager.self)
        
        let localizationManager = LocalizationManager(userManager: userManager)
        container.register(localizationManager, for: LocalizationManager.self)
    }
    
    public func reset() {
        @Injected var userManager: UserManager
        userManager.deleteUser()
        container.reset()
    }
}
