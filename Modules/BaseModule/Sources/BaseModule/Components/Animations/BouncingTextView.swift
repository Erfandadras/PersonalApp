//
//  BouncingTextView.swift
//  BaseModule
//
//  Created by Erfan mac mini on 11/28/25.
//

import SwiftUI

public struct BouncingTextView: View {
    let text: String
    let font: Font
    let color: Color
    
    @Binding private var animationData: AnimationData
    @State private var letterBounce: [CGFloat] = []
    @State private var letterOpacity: [Double] = []
    
    public init(
        text: String,
        font: Font = .largeTitle,
        color: Color = .white,
        animationData: Binding<AnimationData>
    ) {
        self.text = text
        self.font = font
        self.color = color
        self._animationData = animationData
    }
    
    public var body: some View {
        HStack(spacing: 1) {
            ForEach(Array(text.enumerated()), id: \.offset) { index, letter in
                Text(String(letter))
                    .font(font)
                    .foregroundColor(color)
                    .opacity(letterOpacity.indices.contains(index) ? letterOpacity[index] : 0)
                    .offset(y: letterBounce.indices.contains(index) ? letterBounce[index] : -80)
                    .shadow(color: color.opacity(0.3), radius: 5, x: 0, y: 3)
            }
        }
        .onChange(of: animationData.shouldStart, { _, newValue in
            if newValue {
                startAnimation()
            }
        })
    }
    
    private func startAnimation() {
        // Initialize arrays
        letterBounce = Array(repeating: -80, count: text.count)
        letterOpacity = Array(repeating: 0.0, count: text.count)
        
        // Animate each letter
        for index in 0..<text.count {
            let delay = animationData.delay + (Double(index) * 0.25)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                // First bounce down
                withAnimation(.easeOut(duration: 0.3)) {
                    letterBounce[index] = 35
                    letterOpacity[index] = 1.0
                }
                
                // First bounce down
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){
                    withAnimation(.easeOut(duration: 0.3)) {
                        letterBounce[index] = -25
                        letterOpacity[index] = 1.0
                    }
                }
                // Settle to final position
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                        letterBounce[index] = 0
                    } completion: {
                        if index == text.count - 1 {
                            self.animationData.finished = true
                        }
                    }
                }
            }
        }
    }
}
