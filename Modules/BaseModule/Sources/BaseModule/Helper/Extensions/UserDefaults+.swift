//
//  UserDefaults+.swift
//  BaseModule
//
//  Created by Erfan mac mini on 11/15/25.
//

import Foundation

public extension UserDefaults {
    subscript<T>(key: String) -> T? {
        get {
            return value(forKey: key) as? T
        }
        set {
            set(newValue, forKey: key)
        }
    }
}
