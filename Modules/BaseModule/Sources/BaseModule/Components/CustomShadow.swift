//
//  CustomShadow.swift
//  BaseModule
//
//  Created by Erfan mac mini on 11/19/25.
//

import SwiftUI

public struct CustomShadow {
   var color: Color = .clear
   var radius: CGFloat = 0
   var x: CGFloat = 0
   var y: CGFloat = 0
    
    // MARK: - init shadow
    public init (color: Color = .clear, radius: CGFloat = 0, x: CGFloat = 0, y: CGFloat = 0) {
        self.color = color
        self.radius = radius
        self.x = x
        self.y = y
    }
}
