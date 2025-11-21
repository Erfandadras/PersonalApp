//
//  Bundle+language.swift
//  BaseModule
//
//  Created by Erfan mac mini on 11/21/25.
//

import Foundation

extension Bundle {
    private static var bundle: Bundle!
    
    static func setLanguage(language: String) {
        let path = Bundle.module.path(forResource: language, ofType: "lproj")
        bundle = path != nil ? Bundle(path: path!) : .module
    }
    
    static func localizedBundle() -> Bundle {
        return bundle ?? .module
    }
}
