//
//  Color+Dynamic.swift
//  BaseModule
//
//  Created by Erfan mac mini on 11/20/25.
//

import SwiftUI

public extension Color {
    /// Creates a dynamic color that adapts to light and dark mode
    /// - Parameters:
    ///   - light: Color to use in light mode
    ///   - dark: Color to use in dark mode
    /// - Returns: A Color that automatically switches based on appearance
    static func adaptive(light: Color, dark: Color) -> Color {
        Color(UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? UIColor(dark) : UIColor(light)
        })
    }
    
    /// Creates a dynamic color from hex values
    /// - Parameters:
    ///   - lightHex: Hex string for light mode (e.g., "#FFFFFF" or "FFFFFF")
    ///   - darkHex: Hex string for dark mode
    /// - Returns: A Color that automatically switches based on appearance
    static func adaptive(lightHex: String, darkHex: String) -> Color {
        Color(UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark 
                ? UIColor(hexString: darkHex) 
                : UIColor(hexString: lightHex)
        })
    }
    
    /// Creates a dynamic color with different opacities for light and dark mode
    /// - Parameters:
    ///   - baseColor: The base color to use
    ///   - lightOpacity: Opacity for light mode (0.0 - 1.0)
    ///   - darkOpacity: Opacity for dark mode (0.0 - 1.0)
    /// - Returns: A Color that automatically switches opacity based on appearance
    static func adaptive(baseColor: Color, lightOpacity: Double, darkOpacity: Double) -> Color {
        Color(UIColor { traitCollection in
            let opacity = traitCollection.userInterfaceStyle == .dark ? darkOpacity : lightOpacity
            return UIColor(baseColor.opacity(opacity))
        })
    }
    
    /// Initialize Color from hex string
    /// - Parameter hex: Hex string (e.g., "#FFFFFF" or "FFFFFF")
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - UIColor Extension
extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        
        self.init(
            red: CGFloat(r) / 255,
            green: CGFloat(g) / 255,
            blue: CGFloat(b) / 255,
            alpha: CGFloat(a) / 255
        )
    }
}

