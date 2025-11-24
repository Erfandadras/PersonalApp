//
//  View+Localization.swift
//  BaseModule
//
//  Created by Erfan mac mini on 11/20/25.
//

import SwiftUI

public extension View {
    /// Apply localization environment to the view
    /// Use this for standard views that should fully adapt to RTL/LTR
    func withLocalization(_ localizationManager: LocalizationManager) -> some View {
        self
            .environment(\.layoutDirection, localizationManager.layoutDirection)
            .environment(\.locale, localizationManager.locale)
    }
    
    /// Apply only locale without changing layout direction
    /// Use this for Lists and views that shouldn't mirror
    func withLocaleOnly(_ localizationManager: LocalizationManager) -> some View {
        self.environment(\.locale, localizationManager.locale)
    }
}

public extension Text {
    /// Force LTR for specific content (like numbers, codes)
    func forceLTR() -> some View {
        self.environment(\.layoutDirection, .leftToRight)
    }
    
    /// Force RTL for specific content
    func forceRTL() -> some View {
        self.environment(\.layoutDirection, .rightToLeft)
    }
}


