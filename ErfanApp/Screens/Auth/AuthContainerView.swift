//
//  AuthContainerView.swift
//  ErfanApp
//
//  Created by Erfan mac mini on 11/24/25.
//

import SwiftUI
import BaseModule

struct AuthContainerView: View {
    // MARK: - properties
    @StateObject private var viewModel: AuthViewModel
    @Environment(AppState.self) var appState
    @Environment(ThemeManager.self) var themeManager
    
    // MARK: - init
    init() {
        _viewModel = .init(wrappedValue: .init())
    }
    var body: some View {
        ZStack {
            // Background
            Color(uiColor: .systemBackground)
                .ignoresSafeArea()
            
            // Content
            Group {
                switch viewModel.authState {
                case .login:
                    LoginView()
                        .transition(.asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .trailing)))
                case .signUp:
                    SignUpView()
                        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                case .forgotPassword:
                    ForgotPasswordView()
                        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                }
            }
            .environmentObject(viewModel)
        }
        .onChange(of: viewModel.dataModel.user) { _, newValue in
            if newValue != nil {
                appState.setFlow(.home)
            }
        }
        .toast(toast: $viewModel.toast)
        .animation(.spring(response: 0.5, dampingFraction: 0.8), value: viewModel.authState)
    }
}


#Preview {
    AuthContainerView()
}
