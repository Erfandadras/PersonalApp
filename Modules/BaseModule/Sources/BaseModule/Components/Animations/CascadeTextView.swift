//
//  CascadeTextView.swift
//  ErfanApp
//
//  Created by Erfan mac mini on 11/27/25.
//

import SwiftUI

public struct CascadeTextView: View {
    let text: String
    let font: Font
    let color: Color
    
    @Binding private var animationData: AnimationData
    @State private var animatedLetters: [Bool] = []
    
    public init(
        text: String,
        font: Font = .largeTitle,
        color: Color = .white,
        data: Binding<AnimationData>
    ) {
        self.text = text
        self.font = font
        self.color = color
        self._animationData = data
    }
    
    public var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(text.enumerated()), id: \.offset) { index, letter in
                Text(String(letter))
                    .font(font)
                    .foregroundColor(color)
                    .opacity(animatedLetters.indices.contains(index) && animatedLetters[index] ? 1 : 0)
                    .offset(y: animatedLetters.indices.contains(index) && animatedLetters[index] ? 0 : -50)
                    .rotationEffect(.degrees(animatedLetters.indices.contains(index) && animatedLetters[index] ? 0 : -15))
                    .animation(
                        .spring(response: animationData.duration, dampingFraction: 1.2)
                        .delay(Double(index) * animationData.delay),
                        value: animatedLetters.indices.contains(index) ? animatedLetters[index] : false
                    )
            }
        }
        .onAppear {
            // Initialize array with false values
            animatedLetters = Array(repeating: false, count: text.count)
            
            // Trigger animation after startDelay
            DispatchQueue.main.asyncAfter(deadline: .now() + animationData.delay + 0.1) {
                for index in 0..<text.count {
                    animatedLetters[index] = true
                }
            }
        }
    }
}

// MARK: - Alternative Falling Effect
struct FallingTextView: View {
    let text: String
    let font: Font
    let color: Color
    let startDelay: Double
    
    @State private var letterStates: [LetterState] = []
    
    private struct LetterState {
        var isVisible: Bool = false
        var offset: CGFloat = -100
        var rotation: Double = 0
        var scale: CGFloat = 0.5
    }
    
    init(
        text: String,
        font: Font = .largeTitle,
        color: Color = .white,
        startDelay: Double = 0
    ) {
        self.text = text
        self.font = font
        self.color = color
        self.startDelay = startDelay
    }
    
    var body: some View {
        HStack(spacing: 2) {
            ForEach(Array(text.enumerated()), id: \.offset) { index, letter in
                Text(String(letter))
                    .font(font)
                    .foregroundColor(color)
                    .opacity(letterStates.indices.contains(index) && letterStates[index].isVisible ? 1 : 0)
                    .offset(y: letterStates.indices.contains(index) ? letterStates[index].offset : -100)
                    .rotationEffect(.degrees(letterStates.indices.contains(index) ? letterStates[index].rotation : -45))
                    .scaleEffect(letterStates.indices.contains(index) ? letterStates[index].scale : 0.5)
                    .shadow(
                        color: color.opacity(0.5),
                        radius: letterStates.indices.contains(index) && letterStates[index].isVisible ? 8 : 0,
                        x: 0,
                        y: 4
                    )
            }
        }
        .onAppear {
            // Initialize letter states
            letterStates = Array(repeating: LetterState(), count: text.count)
            
            // Animate each letter with staggered delay
            for index in 0..<text.count {
                let delay = startDelay + (Double(index) * 0.1)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                    withAnimation(.spring(response: 0.8, dampingFraction: 0.65)) {
                        letterStates[index].isVisible = true
                        letterStates[index].offset = 0
                        letterStates[index].rotation = 0
                        letterStates[index].scale = 1.0
                    }
                }
            }
        }
    }
}

