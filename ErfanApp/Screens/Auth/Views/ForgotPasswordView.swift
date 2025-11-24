//
//  ForgotPasswordView.swift
//  ErfanApp
//
//  Created by Erfan mac mini on 11/24/25.
//

import SwiftUI
import BaseModule

struct ForgotPasswordView: View {
    @ObservedObject var viewModel: AuthViewModel
    @FocusState private var focusedField: Field?
    
    enum Field {
        case email
    }
    
    var body: some View {
        VStack(spacing: 24) {
            // Header
            VStack(spacing: 8) {
                Text("Reset Password")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.primary)
                
                Text("Enter your email to receive instructions")
                    .font(.subheadline)
                    .foregroundStyle(Color.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.top, 40)
            .padding(.bottom, 20)
            
            // Form
            VStack(spacing: 16) {
                TextField("Email", text: $viewModel.email)
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color(uiColor: .secondarySystemBackground))
                    .cornerRadius(12)
                    .focused($focusedField, equals: .email)
                    .submitLabel(.go)
                    .onSubmit { viewModel.handlePrimaryAction() }
            }
            
            // Reset Button
            Button(action: viewModel.handlePrimaryAction) {
                if viewModel.isLoading {
                    ProgressView()
                        .tint(.white)
                } else {
                    Text("Send Reset Link")
                        .font(.headline)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                }
            }
            .frame(height: 50)
            .frame(maxWidth: .infinity)
            .background(viewModel.isFormValid ? Color.blue : Color.gray.opacity(0.3))
            .foregroundStyle(.white)
            .cornerRadius(16)
            .disabled(!viewModel.isFormValid || viewModel.isLoading)
            .animation(.easeInOut, value: viewModel.isFormValid)
            
            Spacer()
            
            // Footer
            Button(action: { viewModel.switchState(to: .login) }) {
                Text("Back to Login")
                    .fontWeight(.bold)
                    .foregroundStyle(Color.blue)
            }
            .font(.callout)
        }
        .padding(.horizontal, 24)
        .background(Color(uiColor: .systemBackground))
        .onTapGesture {
            focusedField = nil
        }
    }
}
