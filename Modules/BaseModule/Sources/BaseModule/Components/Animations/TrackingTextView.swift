//
//  TrackingTextView.swift
//  ErfanApp
//
//  Created by Erfan mac mini on 11/27/25.
//

import SwiftUI

/// Text view with fade and letter tracking (spacing) animation
public struct TrackingTextView: View {
    let text: String
    let font: Font
    let color: Color
    @Binding private var animationData: AnimationData
    @State private var opacity: Double = 0
    @State private var tracking: CGFloat = 50
    
    public init(
        text: String,
        font: Font = .body,
        color: Color = .white,
        animationData: Binding<AnimationData>
    ) {
        self.text = text
        self.font = font
        self.color = color
        self._animationData = animationData
    }
    
    public var body: some View {
        Text(text)
            .font(font)
            .foregroundColor(color)
            .tracking(tracking)
            .opacity(opacity)
            .onChange(of: animationData.shouldStart, { _, newValue in
                if newValue {
                    startAnimation()
                }
            })
    }
    
    private func startAnimation() {
        DispatchQueue.main.asyncAfter(deadline: .now() + animationData.delay) {
            withAnimation(.easeOut(duration: 1.2)) {
                tracking = 0
                opacity = 1.0
            } completion: {
                animationData.finished = true
            }
        }
    }
}
