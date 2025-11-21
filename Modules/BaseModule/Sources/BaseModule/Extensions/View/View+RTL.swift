//
//  View+RTL.swift
//  BaseModule
//
//  Created by Erfan mac mini on 11/20/25.
//

import SwiftUI

public extension View {
    /// Flip horizontally for RTL languages (for directional icons/images)
    func flippedForRTL(_ isRTL: Bool) -> some View {
        self.scaleEffect(x: isRTL ? -1 : 1, y: 1)
    }
    
    /// Apply padding that respects layout direction
    func leadingPadding(_ value: CGFloat) -> some View {
        self.padding(.leading, value)
    }
    
    func trailingPadding(_ value: CGFloat) -> some View {
        self.padding(.trailing, value)
    }
    
    /// Fix List mirroring issue - keeps List content natural
    func preventListMirroring() -> some View {
        self.environment(\.layoutDirection, .leftToRight)
    }
}

public extension HorizontalAlignment {
    /// Alignment that flips for RTL
    static func adaptive(isRTL: Bool) -> HorizontalAlignment {
        isRTL ? .trailing : .leading
    }
}

public extension Alignment {
    /// Alignment that flips for RTL
    static func adaptiveLeading(isRTL: Bool) -> Alignment {
        isRTL ? .trailing : .leading
    }
    
    static func adaptiveTrailing(isRTL: Bool) -> Alignment {
        isRTL ? .leading : .trailing
    }
}

