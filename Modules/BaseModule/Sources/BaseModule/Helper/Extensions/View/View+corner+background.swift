//
//  File.swift
//  BaseModule
//
//  Created by Erfan mac mini on 11/19/25.
//

import SwiftUI

public extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
    
    /// when you want to set corner and shadow and background
    func cornerRadius(_ radius: CGFloat,
                      backgroundColor: Color,
                      shadow: CustomShadow...) -> some View {
        self.background {
            if shadow.isEmpty {
                RoundedRectangle(cornerRadius: radius, style: .continuous)
                    .fill(backgroundColor)
            } else {
                RoundedRectangle(cornerRadius: radius, style: .continuous)
                    .fill(backgroundColor)
                    .shadowModifier(shadow)
            }
        }
    }
    
    
    func setBackgroundStyle(style: BackgroundStyles) -> some View {
        self.overlay {
            if let border = style.border {
                RoundedRectangle(cornerRadius: style.radius, style: .continuous)
                    .stroke(border.color, lineWidth: border.width)
            }
        }
        .background {
            if style.shadows.isEmpty {
                RoundedRectangle(cornerRadius: style.radius, style: .continuous)
                    .fill(style.color)
            } else {
                RoundedRectangle(cornerRadius: style.radius, style: .continuous)
                    .fill(style.color)
                    .shadowModifier(style.shadows)
            }
        }
    }
    
    func addBorder(with radius: CGFloat, color: Color, width: CGFloat) -> some View {
        overlay( /// apply a rounded border
            RoundedRectangle(cornerRadius: radius, style: .continuous)
                .stroke(color, lineWidth: width)
                .padding(width/2)
        )
    }
    
    func customShadow(_ shadow: CustomShadow...) -> some View {
        self.shadowModifier(shadow)
    }
    
    func shadowModifier(_ shadows: [CustomShadow]) -> some View {
        ForEach(shadows.indices, id: \.hashValue) { index in
            self.shadow(
                color: shadows[index].color,
                radius: shadows[index].radius,
                x: shadows[index].x,
                y: shadows[index].y
            )
        }
    }
}
