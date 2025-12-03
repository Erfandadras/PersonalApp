//
//  View+placeholder.swift
//  realstate
//
//  Created by Erfan mac mini on 11/20/24.
//

import SwiftUI

public extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
            
            ZStack(alignment: alignment) {
                placeholder().opacity(shouldShow ? 1 : 0)
                self
            }
        }
    
    func leading() -> some View {
        HStack {
            self
            Spacer()
        }
    }
    
    func trailing() -> some View {
        HStack {
            Spacer()
            self
        }
    }
}
