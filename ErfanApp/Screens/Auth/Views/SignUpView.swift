//
//  SignUpView.swift
//  ErfanApp
//
//  Created by Erfan mac mini on 11/24/25.
//

import SwiftUI
import BaseModule

struct SignUpView: View {
    @EnvironmentObject var viewModel: AuthViewModel
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
                AuthTextField("Full Name", $viewModel.dataModel.fullName)
                    .textContentType(.name)
                    .autocapitalization(.words)
                    .focused($focusedField, equals: .fullName)
                    .submitLabel(.next)
                    .onSubmit { focusedField = .email }
                
                AuthTextField("Email", $viewModel.dataModel.email)
                    .autocapitalization(.none)
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                    .focused($focusedField, equals: .email)
                    .submitLabel(.next)
                    .onSubmit { focusedField = .password }
                    .spaceHinted(hintModel: $viewModel.dataModel.emailHint)
                
                SecureField("Password", text: $viewModel.dataModel.password)
                    .textContentType(.newPassword)
                    .padding()
                    .background(Color(uiColor: .secondarySystemBackground))
                    .cornerRadius(12)
                    .focused($focusedField, equals: .password)
                    .submitLabel(.next)
                    .onSubmit { focusedField = .confirmPassword }
                
                SecureField("Confirm Password", text: $viewModel.dataModel.confirmPassword)
                    .textContentType(.newPassword)
                    .padding()
                    .background(Color(uiColor: .secondarySystemBackground))
                    .cornerRadius(12)
                    .focused($focusedField, equals: .confirmPassword)
                    .submitLabel(.go)
                    .onSubmit { viewModel.login() }
                    .spaceHinted(hintModel: $viewModel.dataModel.confirmPasswordHint)
            }
            
            // Sign Up Button
            Button(action: viewModel.register) {
                if viewModel.dataModel.registerLoading {
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
            .background(Color.blue)
            .foregroundStyle(.white)
            .cornerRadius(16)
            .animation(.easeInOut, value: viewModel.dataModel.registerFormValidation)
            
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
