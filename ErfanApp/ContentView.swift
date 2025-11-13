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
    private let base = Base()
    private let service = Service()
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "cube.box.fill")
                .imageScale(.large)
                .foregroundStyle(.tint)
                .font(.system(size: 60))
            
            Text("Modular Architecture Demo")
                .font(.title)
                .fontWeight(.bold)
            
            VStack(alignment: .leading, spacing: 10) {
                Text(base.hello())
                    .font(.body)
                    .foregroundStyle(.secondary)
                
                Text(service.hello())
                    .font(.body)
                    .foregroundStyle(.secondary)
                
                Text(service.getAppInfo())
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.1))
            )
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
