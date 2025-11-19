//
//  RoundedCorner.swift
//  BaseModule
//
//  Created by Erfan mac mini on 11/19/25.
//

import SwiftUI

public struct RoundedCorner: Shape {
    let radius: CGFloat
    let corners: UIRectCorner

    public init(radius: CGFloat = .infinity, corners: UIRectCorner = .allCorners) {
        self.radius = radius
        self.corners = corners
    }

    public func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: 0))
        return Path(path.cgPath)
    }
}
