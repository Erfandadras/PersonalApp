//
//  HomeItemView.swift
//  ErfanApp
//
//  Created by Erfan mac mini on 12/2/25.
//

import SwiftUI
import BaseModule

struct HomeItemView: View {
    let title: String
    let description: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: defaultVPadding/2) {
                Text(title)
                    .font(.ui.largSemiBold)
                    .foregroundStyle(.ui.black)
                
                Text(description)
                    .font(.ui.mRegular)
                    .foregroundStyle(.ui.textSecondary)
            }
        }
    }
}
