//
//  LazyView.swift
//  realstate
//
//  Created by Erfan mac mini on 11/12/24.
//

import SwiftUI
/// make view keep its state and be stored in memory
public struct LazyView<Content: View>: View {
    let build: () -> Content
    
    public init(_ build: @escaping () -> Content) {
        self.build = build
    }
    
    public var body: Content {
        build()
    }
}
