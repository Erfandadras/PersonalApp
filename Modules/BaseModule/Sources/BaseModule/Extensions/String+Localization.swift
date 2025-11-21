//
//  String+Localization.swift
//  BaseModule
//
//  Created by Erfan mac mini on 11/20/25.
//

import Foundation

public extension String {
    /// Get localized version of this string key
    func localized() -> String {
        return NSLocalizedString(self,
                                 // I Used .module for bundle
                                 bundle: .localizedBundle(),
                                 comment: "")
    }
    
    /// Get localized version with arguments
    func localizedWith(_ arguments: CVarArg...) -> String {
        String(format: self.localized(), arguments: arguments)
    }
}

