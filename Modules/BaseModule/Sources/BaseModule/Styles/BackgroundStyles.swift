//
//  BackgroundStyles.swift
//  BaseModule
//
//  Created by Erfan mac mini on 11/19/25.
//

import SwiftUI

public struct BackgroundStyles {
    var radius: CGFloat
    public var color: Color
    var border: BorderStyles?
    var shadows: [CustomShadow]
    var blur: CGFloat?
    
    public init(radius: CGFloat,
                color: Color,
                border: BorderStyles? = nil,
                blur: CGFloat? = nil,
                shadows: CustomShadow...) {
        self.radius = radius
        self.color = color
        self.shadows = shadows
        self.border = border
        self.blur = blur
    }
    
    public init(radius: CGFloat,
                color: Color,
                border: BorderStyles? = nil,
                blur: CGFloat? = nil,
                shadows: [CustomShadow]) {
        self.radius = radius
        self.color = color
        self.shadows = shadows
        self.border = border
        self.blur = blur
    }
    
    
    public func radious(_ value: CGFloat) -> Self {
        var copy = self
        copy.radius = value
        return copy
    }
    
    public func color(_ value: Color) -> Self {
        var copy = self
        copy.color = color
        return copy
    }
}
