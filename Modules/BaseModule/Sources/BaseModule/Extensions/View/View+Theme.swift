//
//  View+Theme.swift
//  BaseModule
//
//  Created by Erfan mac mini on 11/20/25.
//

import SwiftUI

public extension View {
    /// Apply the theme color scheme to the view
    /// - Parameter themeManager: The theme manager to use
    /// - Returns: Modified view with applied color scheme
    func themedColorScheme(_ themeManager: ThemeManager) -> some View {
        self.preferredColorScheme(themeManager.colorScheme)
            .environment(\.colorScheme, themeManager.colorScheme ?? .light)
    }
}
