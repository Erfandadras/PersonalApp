//
//  UserManager.swift
//  BaseModule
//
//  Created by Erfan mac mini on 11/15/25.
//
import Foundation

final public class UserManager: NSObject {
    private let manager = UserDefaults.standard
    private let themeKey = "app_theme_preference"
    private let languageKey = "AppleLanguages"
    
    // MARK: - init
    public override init() {}
    
    // MARK: - Variables
    public  var userId: Int? {
        get { return manager[#function] }
        set { manager[#function] = newValue }
    }
    
    public var name: String? {
        get { return manager[#function] }
        set { manager[#function] = newValue }
    }
    
    public var email: String? {
        get { return manager[#function] }
        set { manager[#function] = newValue }
    }
    
    public var colorSchema: String? {
        get { return manager[themeKey] }
        set { manager[themeKey] = newValue }
    }
    
    // MARK: - Methods
    public func deleteUser() {
        let dictionary = manager.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            manager.removeObject(forKey: key)
        }
    }
    
    public func clear() {
        let dictionary = manager.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            manager.removeObject(forKey: key)
        }
    }
    
    public func updateLanguage(localCode: String) {
        manager.set([localCode], forKey: languageKey)
        manager.set(localCode, forKey: "app_lang")
        manager.synchronize()
    }
}
