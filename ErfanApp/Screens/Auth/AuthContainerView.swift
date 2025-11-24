//
//  AuthContainerView.swift
//  ErfanApp
//
//  Created by Erfan mac mini on 11/24/25.
//

import SwiftUI
import BaseModule

struct AuthContainerView: View {
    @StateObject private var viewModel = AuthViewModel()
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        ZStack {
            // Background
            Color(uiColor: .systemBackground)
                .ignoresSafeArea()
            
            // Content
            Group {
                switch viewModel.authState {
                case .login:
                    LoginView(viewModel: viewModel)
                        .transition(.asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .trailing)))
                case .signUp:
                    SignUpView(viewModel: viewModel)
                        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                case .forgotPassword:
                    ForgotPasswordView(viewModel: viewModel)
                        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                }
            }
        }
        .alert(isPresented: $viewModel.showError) {
            Alert(
                title: Text("Error"),
                message: Text(viewModel.errorMessage ?? "An unknown error occurred"),
                dismissButton: .default(Text("OK"))
            )
        }
        .animation(.spring(response: 0.5, dampingFraction: 0.8), value: viewModel.authState)
    }
}


#Preview {
    AuthContainerView()
}
