//
//  AuthTextField.swift
//  ErfanApp
//
//  Created by Erfan mac mini on 12/3/25.
//

import SwiftUI

struct AuthTextField: View {
    // MARK: - properties
    var placeholder: String
    @Binding var value: String
    
    // MARK: - init
    init(_ placeholder: String, _ value: Binding<String>) {
        self.placeholder = placeholder
        self._value = value
    }
    // MARK: - view
    var body: some View {
        TextField(placeholder, text: $value)
            .padding()
            .background(Color(uiColor: .secondarySystemBackground))
            .cornerRadius(12)
    }
}
