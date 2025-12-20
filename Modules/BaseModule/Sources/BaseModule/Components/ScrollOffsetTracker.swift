//
//  ScrollOffsetTracker.swift
//  realstate
//
//  Created by Erfan mac mini on 12/7/24.
//

import SwiftUI

public struct ScrollOffsetTracker: ViewModifier {
    var completion: ((CGPoint) -> Void)
    let coordinatorSpace: String
    public func body(content: Content) -> some View {
        content
            .background(GeometryReader { geometry in
                Color.clear
                    .preference(key: PointPreferenceKey.self,
                                value: CGPoint(x: geometry.frame(in: .named(coordinatorSpace)).minX,
                                               y: geometry.frame(in: .named(coordinatorSpace)).minY))
            })
            .onPreferenceChange(PointPreferenceKey.self) { newValue in
                DispatchQueue.main.async {
                    completion(newValue)
                }
            }
    }
}

public struct PointPreferenceKey: PreferenceKey {
    public static var defaultValue: CGPoint = .zero
    public static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) { }
}

/// This modifier should use for LazyVStack/LazyHStack content.
public extension View {
    func trackOffset(completion: @escaping ((CGPoint) -> Void),
                     coordinatorSpace: String) -> some View {
        modifier(ScrollOffsetTracker(completion: completion, coordinatorSpace: coordinatorSpace))
    }
}

