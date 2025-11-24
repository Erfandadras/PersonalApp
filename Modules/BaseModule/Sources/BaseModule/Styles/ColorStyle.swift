//
//  ColorStyle.swift
//  BaseModule
//
//  Created by Erfan mac mini on 11/19/25.
//

import SwiftUI

public extension ShapeStyle where Self == Color {
    static var ui: ColorStyle.Type { ColorStyle.self }
}

public struct ColorStyle {
    // MARK: - Asset Catalog Colors
    /// gray 100 #F3F4F6
    public static let gray1: Color = Color("gray1", bundle: .module)
    /// secondaryBg #F3F4F6
    public static let secondaryBg: Color = Color("secondaryBg", bundle: .module)
    /// secondary #222222
    public static let secondary: Color = Color("secondary", bundle: .module)
    /// black - automatically adapts to white in dark mode
    public static let black: Color = Color("black", bundle: .module)
    
    // MARK: - Dynamic Colors (for complex cases)
    public static let white: Color = .adaptive(
        light: Color(hex: "#FFFFFF"),
        dark: Color(hex: "#000000")
    )
    /// Dynamic text color - high contrast in both modes
    public static let textPrimary: Color = .adaptive(
        light: Color(hex: "#000000"),
        dark: Color(hex: "#FFFFFF")
    )
    
    /// Dynamic text color - medium contrast
    public static let textSecondary: Color = .adaptive(
        light: Color(hex: "#6B7280"),
        dark: Color(hex: "#9CA3AF")
    )
    
    /// Dynamic background with subtle difference
    public static let cardBackground: Color = .adaptive(
        light: Color(hex: "#FFFFFF"),
        dark: Color(hex: "#1F2937")
    )
    
    /// Dynamic border color
    public static let border: Color = .adaptive(
        light: Color(hex: "#E5E7EB"),
        dark: Color(hex: "#374151")
    )
    
    /// Dynamic shadow color with different opacities
    public static let shadowColor: Color = .adaptive(
        baseColor: .black,
        lightOpacity: 0.1,
        darkOpacity: 0.3
    )
    
    /// Dynamic overlay color for modals/sheets
    public static let overlay: Color = .adaptive(
        baseColor: .black,
        lightOpacity: 0.4,
        darkOpacity: 0.6
    )
}
