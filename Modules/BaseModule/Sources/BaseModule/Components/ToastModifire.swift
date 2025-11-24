//
//  ToastModifire.swift
//  realstate
//
//  Created by Erfan mac mini on 11/14/24.
//

import SwiftUI

public enum ToastType {
    case success
    case info
    case error
}

public struct Toast: Equatable {
    let type: ToastType
    let message: String
    var duration: Double = 2.0
    
    public init(type: ToastType, message: String, duration: Double = 2.0) {
        self.type = type
        self.message = message
        self.duration = duration
    }
}

public struct ToastModifier: ViewModifier {
    // State for the toast message and visibility
    @Binding var toast: Toast?
    var padding: CGFloat = 50
    
    public func body(content: Content) -> some View {
        ZStack {
            content
            if toast != nil {
                VStack {
                    Spacer()
                    ToastView(message: toast!.message)
                        .padding(.bottom, padding) // Adjust as needed for toast position
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .animation(.easeInOut(duration: 0.3), value: toast)
                }
            }
        }
        .onChange(of: toast) { newValue in
            guard let newValue else { return }
            // Hide the toast after a delay
            DispatchQueue.main.asyncAfter(deadline: .now() + newValue.duration) {
                withAnimation {
                    toast = nil
                }
            }
        }
    }
}


public extension View {
    func toast(toast: Binding<Toast?>, padding: CGFloat = 50) -> some View {
        self.modifier(ToastModifier(toast: toast, padding: padding))
    }
}
