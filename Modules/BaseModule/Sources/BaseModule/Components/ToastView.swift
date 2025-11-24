//
//  ToastView.swift
//  realstate
//
//  Created by Erfan mac mini on 11/14/24.
//


import SwiftUI

public struct ToastView: View {
    var message: String
    
    public var body: some View {
        Text(message)
            .font(.ui.mSemiBold)
            .padding()
            .background(Color.black.opacity(0.8))
            .foregroundColor(.ui.white)
            .cornerRadius(8)
            .shadow(radius: 5)
            .multilineTextAlignment(.center)
    }
}
