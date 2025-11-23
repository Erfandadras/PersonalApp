//
//  ContentView.swift
//  ErfanApp
//
//  Created by Erfan mac mini on 11/13/25.
//

import SwiftUI
import ServiceModule
import BaseModule

struct ContentView: View {
    private let service = Service()
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "cube.box.fill")
                .imageScale(.large)
                .foregroundStyle(.tint)
                .font(.system(size: 60))
            
            Text("Modular Architecture Demo")
                .font(.ui.largSemiBold) // custom font
            
            VStack(alignment: .leading, spacing: 10) {
                Text(service.hello())
                    .font(.ui.mSemiBold) // custom font
                    .foregroundStyle(.ui.secondary) // custom color
                
                Text(service.getAppInfo())
                    .font(.ui.xsSemiBold) // custom font
                    .foregroundStyle(.ui.secondary) // custom color
            }
            .padding()
            .background(
                Color.ui.secondaryBg.ignoresSafeArea()
            )
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
