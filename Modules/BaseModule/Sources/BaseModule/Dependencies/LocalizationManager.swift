//
//  LocalizationManager.swift
//  BaseModule
//
//  Created by Erfan mac mini on 11/20/25.
//

import SwiftUI
import Combine

public enum AppLanguage: String, CaseIterable {
    case english = "en"
    case arabic = "ar"
    
    public var displayName: String {
        switch self {
        case .english: return "English"
        case .arabic: return "العربية"
        }
    }
    
    public var locale: Locale {
        Locale(identifier: rawValue)
    }
    
    public var layoutDirection: LayoutDirection {
        switch self {
        case .english: return .leftToRight
        case .arabic: return .rightToLeft
        }
    }
}

/// LocalizationManager handles app language and layout direction
/// Uses UserManager for persistence and supports runtime language switching
final public class LocalizationManager: ObservableObject {
    @AppStorage("currentLanguage")
    private var storedLanguage: AppLanguage = .english
    private let userManager: UserManager
    
    // MARK: - Properties
    @Published public private(set) var currentLanguage: AppLanguage = .english {
        didSet {
            saveLanguage()
        }
    }
    
    // MARK: - Init
    public init(userManager: UserManager) {
        // Load saved language or default to English
        self.userManager = userManager
        self.currentLanguage = storedLanguage
        saveLanguage()
    }
    
    // MARK: - Computed Properties
    /// Current layout direction
    public var layoutDirection: LayoutDirection {
        currentLanguage.layoutDirection
    }
    
    /// Check if current language is RTL
    public var isRTL: Bool {
        currentLanguage.layoutDirection == .rightToLeft
    }
    
    /// Current locale
    public var locale: Locale {
        currentLanguage.locale
    }
    
    // MARK: - Public Methods
    /// Change app language
    public func setLanguage(_ language: AppLanguage) {
        currentLanguage = language
    }
    
    /// Toggle between available languages
    public func toggleLanguage() {
        let allLanguages = AppLanguage.allCases
        guard let currentIndex = allLanguages.firstIndex(of: currentLanguage) else { return }
        let nextIndex = (currentIndex + 1) % allLanguages.count
        setLanguage(allLanguages[nextIndex])
    }
    
    // MARK: - Private Methods
    private func saveLanguage() {
        storedLanguage = currentLanguage
        userManager.updateLanguage(localCode: currentLanguage.rawValue)
        Bundle.setLanguage(language: currentLanguage.rawValue)
    }
}

// MARK: - Environment Key
private struct LocalizationManagerKey: EnvironmentKey {
    static let defaultValue: LocalizationManager? = nil
}

public extension EnvironmentValues {
    var localizationManager: LocalizationManager? {
        get { self[LocalizationManagerKey.self] }
        set { self[LocalizationManagerKey.self] = newValue }
    }
}

