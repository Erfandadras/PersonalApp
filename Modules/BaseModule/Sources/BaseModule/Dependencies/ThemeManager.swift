//
//  ThemeManager.swift
//  BaseModule
//
//  Created by Erfan mac mini on 11/20/25.
//

import SwiftUI
import Combine

public enum AppTheme: String, CaseIterable {
    case light
    case dark
    case system
    
    public var displayName: String {
        switch self {
        case .light: return "Light"
        case .dark: return "Dark"
        case .system: return "System"
        }
    }
}

/// ThemeManager handles the app's color scheme management
/// Uses UserManager for persistence and supports manual theme switching

@Observable
final public class ThemeManager{
    // MARK: - Properties
    public private(set) var currentTheme: AppTheme {
        didSet {
            saveTheme()
        }
    }
    private let userManager: UserManager
    
    // MARK: - Init
    public init(userManager: UserManager) {
        self.userManager = userManager
        
        // Load saved theme or default to system
        if let savedThemeRaw = userManager.colorSchema,
           let savedTheme = AppTheme(rawValue: savedThemeRaw) {
            self.currentTheme = savedTheme
        } else {
            self.currentTheme = .system
        }
    }
    
    // MARK: - Computed Properties
    /// Returns the ColorScheme based on current theme, nil means system
    public var colorScheme: ColorScheme? {
        switch currentTheme {
        case .light: return .light
        case .dark: return .dark
        case .system: return nil
        }
    }
    
    /// Check if dark mode is currently active
    public var isDarkMode: Bool {
        switch currentTheme {
        case .dark: return true
        case .light: return false
        case .system:
            // Check system appearance
            return UITraitCollection.current.userInterfaceStyle == .dark
        }
    }
    
    // MARK: - Public Methods
    /// Change the app theme
    public func setTheme(_ theme: AppTheme) {
        withAnimation(.easeInOut(duration: 0.6)) {
            currentTheme = theme
        }
    }
    
    /// Toggle between light and dark (ignores system)
    public func toggleTheme() {
        switch currentTheme {
        case .light:
            setTheme(.dark)
        case .dark:
            setTheme(.light)
        case .system:
            // If on system, switch to opposite of current system appearance
            setTheme(isDarkMode ? .light : .dark)
        }
    }
    
    /// Reset to system theme
    public func resetToSystem() {
        setTheme(.system)
    }
    
    // MARK: - Private Methods
    private func saveTheme() {
        userManager.colorSchema = currentTheme.rawValue
    }
    
    /// Clear theme preference (used when clearing user data)
    public func clearThemePreference() {
        userManager.colorSchema = nil
        currentTheme = .system
    }
}


// MARK: - Environment Key for ThemeManager
private struct ThemeManagerKey: EnvironmentKey {
    static let defaultValue: ThemeManager? = nil
}

public extension EnvironmentValues {
    var themeManager: ThemeManager? {
        get { self[ThemeManagerKey.self] }
        set { self[ThemeManagerKey.self] = newValue }
    }
}
