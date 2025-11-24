//
//  ErfanAppApp.swift
//  ErfanApp
//
//  Created by Erfan mac mini on 11/13/25.
//

import SwiftUI
import BaseModule

@main
struct ErfanAppApp: App {
    // MARK: - properties
    @MainActor
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject var themeManager: ThemeManager
    @StateObject var localizationManager: LocalizationManager
    
    // MARK: - init
    init() {
        UIFont.loadAll()
        @Injected var themeManager: ThemeManager
        @Injected var localizationManager: LocalizationManager
        self._themeManager = .init(wrappedValue: themeManager)
        self._localizationManager = .init(wrappedValue: localizationManager)
        
    }
    
    // MARK: - view
    var body: some Scene {
        WindowGroup {
            AuthContainerView()
                .id(localizationManager.currentLanguage) // by adding this line the mirror bug fixed
                .environmentObject(themeManager)
                .environmentObject(localizationManager)
                .themedColorScheme(themeManager)
                .withLocalization(localizationManager)
        }
    }
}
