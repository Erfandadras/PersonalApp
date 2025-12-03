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
    @State private var appState: AppState
    @State var themeManager: ThemeManager
    @StateObject var localizationManager: LocalizationManager
    
    // MARK: - init
    init() {
        CoreDependence().execute()
        @Injected var themeManager: ThemeManager
        @Injected var localizationManager: LocalizationManager
        self._themeManager = .init(wrappedValue: themeManager)
        self._localizationManager = .init(wrappedValue: localizationManager)
        self._appState = .init(initialValue: .init())
    }
    
    // MARK: - view
    var body: some Scene {
        WindowGroup {
            Group {
                switch appState.flow {
                case .splash:
                    SplashView()
                        .transition(.opacity)
                case .home:
                    HomeView()
                        .transition(.opacity.combined(with: .scale))
                case .login:
                    AuthContainerView()
                        .transition(.opacity.combined(with: .scale))
                }
            }
            .animation(.easeInOut(duration: 0.5), value: appState.flow)
            .id(localizationManager.currentLanguage) // by adding this line the mirror bug fixed
            .environment(appState)
            .environment(themeManager)
            .environmentObject(localizationManager)
            .themedColorScheme(themeManager)
            .withLocalization(localizationManager)
        }
    }
}
