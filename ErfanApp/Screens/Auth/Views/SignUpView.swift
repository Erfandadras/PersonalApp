//
//  SignUpView.swift
//  ErfanApp
//
//  Created by Erfan mac mini on 11/24/25.
//

import SwiftUI
import BaseModule

struct SignUpView: View {
    @ObservedObject var viewModel: AuthViewModel
    @FocusState private var focusedField: Field?
    
    enum Field {
        case fullName
        case email
        case password
        case confirmPassword
    }
    
    var body: some View {
        VStack(spacing: 24) {
            // Header
            VStack(spacing: 8) {
                Text("Create Account")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.primary)
                
                Text("Join us today")
                    .font(.subheadline)
                    .foregroundStyle(Color.secondary)
            }
            .padding(.top, 40)
            .padding(.bottom, 20)
            
            // Form
            VStack(spacing: 16) {
                TextField("Full Name", text: $viewModel.fullName)
                    .textContentType(.name)
                    .autocapitalization(.words)
                    .padding()
                    .background(Color(uiColor: .secondarySystemBackground))
                    .cornerRadius(12)
                    .focused($focusedField, equals: .fullName)
                    .submitLabel(.next)
                    .onSubmit { focusedField = .email }
                
                TextField("Email", text: $viewModel.email)
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color(uiColor: .secondarySystemBackground))
                    .cornerRadius(12)
                    .focused($focusedField, equals: .email)
                    .submitLabel(.next)
                    .onSubmit { focusedField = .password }
                
                SecureField("Password", text: $viewModel.password)
                    .textContentType(.newPassword)
                    .padding()
                    .background(Color(uiColor: .secondarySystemBackground))
                    .cornerRadius(12)
                    .focused($focusedField, equals: .password)
                    .submitLabel(.next)
                    .onSubmit { focusedField = .confirmPassword }
                
                SecureField("Confirm Password", text: $viewModel.confirmPassword)
                    .textContentType(.newPassword)
                    .padding()
                    .background(Color(uiColor: .secondarySystemBackground))
                    .cornerRadius(12)
                    .focused($focusedField, equals: .confirmPassword)
                    .submitLabel(.go)
                    .onSubmit { viewModel.handlePrimaryAction() }
            }
            
            // Sign Up Button
            Button(action: viewModel.handlePrimaryAction) {
                if viewModel.isLoading {
                    ProgressView()
                        .tint(.white)
                } else {
                    Text("Sign Up")
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
            HStack {
                Text("Already have an account?")
                    .foregroundStyle(Color.secondary)
                Button(action: { viewModel.switchState(to: .login) }) {
                    Text("Log In")
                        .fontWeight(.bold)
                        .foregroundStyle(Color.blue)
                }
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
