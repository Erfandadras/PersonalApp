//
//  ExampleLocalizedView.swift
//  BaseModule
//
//  Created by Erfan mac mini on 11/20/25.
//

import SwiftUI

/// Example demonstrating RTL/LTR and localization usage
public struct ExampleLocalizedView: View {
    @EnvironmentObject var localizationManager: LocalizationManager
    @Environment(ThemeManager.self) var themeManager
    
    public init() {}
    
    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    Text(L.Common.welcome)
                        .font(.largeTitle)
                        .foregroundColor(.ui.textPrimary)
                    
                    Text(L.Common.hello)
                        .font(.title3)
                        .foregroundColor(.ui.textSecondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Divider()
                
                // Auth Section
                VStack(alignment: .leading, spacing: 12) {
                    Text(L.Auth.signIn)
                        .font(.headline)
                    
                    TextField(L.Auth.email, text: .constant(""))
                        .textFieldStyle(.roundedBorder)
                    
                    SecureField(L.Auth.password, text: .constant(""))
                        .textFieldStyle(.roundedBorder)
                    
                    HStack {
                        Button(L.Auth.forgotPassword) {}
                        Spacer()
                        Button(L.Auth.rememberMe) {}
                    }
                    .font(.caption)
                }
                .padding()
                .background(Color.ui.cardBackground)
                .cornerRadius(12)
                
                // Navigation Buttons (with directional icons)
                HStack(spacing: 16) {
                    Button {
                        // Action
                    } label: {
                        HStack {
                            Image(systemName: "arrow.left")
                            Text(L.Buttons.back)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.ui.secondaryBg)
                        .cornerRadius(8)
                    }
                    
                    Button {
                        // Action
                    } label: {
                        HStack {
                            Text(L.Buttons.next)
                            Image(systemName: "arrow.right")
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                }
                
                // Settings Quick Access
                VStack(spacing: 12) {
                    Button {
                        localizationManager.toggleLanguage()
                    } label: {
                        HStack {
                            Image(systemName: "globe")
                            Text(L.Language.changeLanguage)
                            Spacer()
                            Text(localizationManager.currentLanguage.displayName)
                                .foregroundColor(.ui.textSecondary)
                        }
                        .padding()
                        .background(Color.ui.cardBackground)
                        .cornerRadius(8)
                    }
                    
                    Button {
                        themeManager.toggleTheme()
                    } label: {
                        HStack {
                            Image(systemName: themeManager.isDarkMode ? "moon.fill" : "sun.max.fill")
                            Text(L.Theme.appearance)
                            Spacer()
                            Text(themeManager.currentTheme.displayName)
                                .foregroundColor(.ui.textSecondary)
                        }
                        .padding()
                        .background(Color.ui.cardBackground)
                        .cornerRadius(8)
                    }
                }
                
                // Number Example (should stay LTR)
                HStack {
                    Text("Phone Number:")
                    Text("+1234567890")
                }
                .padding()
                .background(Color.ui.secondaryBg)
                .cornerRadius(8)
            }
            .padding()
        }
        .navigationTitle(L.Common.settings)
        .withLocalization(localizationManager)
    }
}

#Preview("English - Light") {
    NavigationView {
        ExampleLocalizedView()
            .environmentObject({
                let locManager = LocalizationManager(userManager: .init())
                locManager.setLanguage(.english)
                return locManager
            }())
            .environment({
                let userManager = UserManager()
                let themeManager = ThemeManager(userManager: userManager)
                themeManager.setTheme(.light)
                return themeManager
            }())
    }
}

#Preview("Arabic - Dark") {
    NavigationView {
        ExampleLocalizedView()
            .environmentObject({
                let locManager = LocalizationManager(userManager: .init())
                locManager.setLanguage(.arabic)
                return locManager
            }())
            .environment({
                let userManager = UserManager()
                let themeManager = ThemeManager(userManager: userManager)
                themeManager.setTheme(.dark)
                return themeManager
            }())
    }
}

