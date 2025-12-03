//
//  HintViewModifier.swift
//  realstate
//
//  Created by Erfan mac mini on 11/26/24.
//

import SwiftUI


public struct HintUIModel: Equatable {
    public var text: String
    let color: Color
    
    public init(text: String, color: Color) {
        self.text = text
        self.color = color
    }
}

public struct HintViewModifier: ViewModifier {
    @Binding var hint: HintUIModel?
    
    public func body(content: Content) -> some View {
        ZStack(alignment: .bottom) {
            content
                .padding(.bottom, defaultVPadding)
            
            if let hint = hint {
                Text(hint.text)
                    .font(.ui.sRegular)
                    .foregroundStyle(hint.color)
                    .leading()
            }
        }
    }
}

public struct HintWithSpaceViewModifier: ViewModifier {
    @Binding var hint: HintUIModel?
    
    public func body(content: Content) -> some View {
        VStack(spacing: 4) {
            content
            if let hint = hint {
                Text(hint.text)
                    .font(.ui.sRegular)
                    .foregroundStyle(hint.color)
                    .leading()
            }
        }.animation(.easeInOut, value: hint)
    }
}


public extension View {
    func hinted(hintModel: Binding<HintUIModel?>) -> some View {
        self.modifier(HintViewModifier(hint: hintModel))
    }
    
    func spaceHinted(hintModel: Binding<HintUIModel?>) -> some View {
        self.modifier(HintWithSpaceViewModifier(hint: hintModel))
    }
}
