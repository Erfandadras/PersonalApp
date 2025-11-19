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
    /// gray 100 #F3F4F6
    public static let gray1: Color = Color("gray1", bundle: .module)
    /// secondaryBg #F3F4F6
    public static let secondaryBg: Color = Color("secondaryBg", bundle: .module)
    /// secondary #222222
    public static let secondary: Color = Color("secondary", bundle: .module)
}
