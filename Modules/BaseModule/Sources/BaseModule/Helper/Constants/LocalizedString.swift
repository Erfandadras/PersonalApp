//
//  localized()String.swift
//  BaseModule
//
//  Created by Erfan mac mini on 11/20/25.
//

import Foundation

/// Type-safe localized() strings
public struct L {
    // MARK: - Common
    public struct Common {
        public static var welcome: String { "welcome".localized() }
        public static var hello: String { "hello".localized() }
        public static var settings: String { "settings".localized() }
        public static var save: String { "save".localized() }
        public static var cancel: String { "cancel".localized() }
        public static var done: String { "done".localized() }
    }
    
    // MARK: - Auth
    public struct Auth {
        public static var signIn: String { "sign_in".localized() }
        public static var signUp: String { "sign_up".localized() }
        public static var email: String { "email".localized() }
        public static var password: String { "password".localized() }
        public static var forgotPassword: String { "forgot_password".localized() }
        public static var rememberMe: String { "remember_me".localized() }
    }
    
    // MARK: - Theme
    public struct Theme {
        public static var theme: String { "theme".localized() }
        public static var lightMode: String { "light_mode".localized() }
        public static var darkMode: String { "dark_mode".localized() }
        public static var systemMode: String { "system_mode".localized() }
        public static var appearance: String { "appearance".localized() }
    }
    
    // MARK: - Language
    public struct Language {
        public static var language: String { "language".localized() }
        public static var english: String { "english".localized() }
        public static var arabic: String { "arabic".localized() }
        public static var changeLanguage: String { "change_language".localized() }
    }
    
    // MARK: - Buttons
    public struct Buttons {
        public static var next: String { "next".localized() }
        public static var back: String { "back".localized() }
        public static var submit: String { "submit".localized() }
        public static var confirm: String { "confirm".localized() }
    }
}

