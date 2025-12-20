//
//  LoginView.swift
//  ErfanApp
//
//  Created by Erfan mac mini on 11/24/25.
//

import SwiftUI
import AuthenticationServices
import BaseModule

struct LoginView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @Environment(AppState.self) var appState
    @Environment(\.colorScheme) var colorScheme
    @FocusState private var focusedField: Field?
    
    enum Field {
        case email
        case password
    }
    
    var body: some View {
        VStack(spacing: 24) {
            // Header
            VStack(spacing: 8) {
                Text("Welcome Back")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.primary)
                
                Text("Sign in to continue")
                    .font(.subheadline)
                    .foregroundStyle(Color.secondary)
            }
            .padding(.top, 40)
            .padding(.bottom, 20)
            
            // Form
            VStack(spacing: 16) {
                TextField("Email", text: $viewModel.dataModel.email)
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color(uiColor: .secondarySystemBackground))
                    .cornerRadius(12)
                    .focused($focusedField, equals: .email)
                    .submitLabel(.next)
                    .onSubmit { focusedField = .password }
                
                SecureField("Password", text: $viewModel.dataModel.password)
                    .textContentType(.password)
                    .padding()
                    .background(Color(uiColor: .secondarySystemBackground))
                    .cornerRadius(12)
                    .focused($focusedField, equals: .password)
                    .submitLabel(.go)
                    .onSubmit { viewModel.login() }
                
                HStack {
                    Spacer()
                    Button(action: { viewModel.switchState(to: .forgotPassword) }) {
                        Text("Forgot Password?")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundStyle(Color.blue)
                    }
                }
            }
            
            // Login Button
            Button(action: viewModel.login) {
                if viewModel.dataModel.signInLoading {
                    ProgressView()
                        .tint(.white)
                } else {
                    Text("Log In")
                        .font(.headline)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                }
            }
            .frame(height: 50)
            .frame(maxWidth: .infinity)
            .background(viewModel.dataModel.loginFormValidation ? Color.blue : Color.gray.opacity(0.3))
            .foregroundStyle(.white)
            .cornerRadius(16)
            .disabled(!viewModel.dataModel.loginFormValidation || viewModel.dataModel.signInLoading)
            .animation(.easeInOut, value: viewModel.dataModel.loginFormValidation)
            
            // Divider
            HStack {
                Rectangle().frame(height: 1).foregroundStyle(Color.gray.opacity(0.3))
                Text("OR").font(.caption).foregroundStyle(Color.secondary)
                Rectangle().frame(height: 1).foregroundStyle(Color.gray.opacity(0.3))
            }
            .padding(.vertical, 10)
            
            // Social Login
            VStack(spacing: 12) {
                SignInWithAppleButton(.signIn) { request in
                    request.requestedScopes = [.fullName, .email]
                } onCompletion: { result in
                    viewModel.handleAppleSignIn(result: result)
                }
                .signInWithAppleButtonStyle(colorScheme == .dark ? .white : .black)
                .frame(height: 50)
                .cornerRadius(12)
                
                Button(action: viewModel.handleGoogleSignIn) {
                    HStack {
                        Image(systemName: "globe") // Placeholder for Google Icon
                        Text("Sign in with Google")
                    }
                    .font(.headline)
                    .fontWeight(.medium)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color(uiColor: .secondarySystemBackground))
                    .foregroundStyle(Color.primary)
                    .cornerRadius(12)
                }
                
                Button(action: viewModel.handlePassKey) {
                    HStack {
                        Image(systemName: "person.badge.key.fill")
                        Text("Sign in with PassKey")
                    }
                    .font(.headline)
                    .fontWeight(.medium)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.indigo.opacity(0.1))
                    .foregroundStyle(Color.indigo)
                    .cornerRadius(12)
                }
            }
            
            Spacer()
            
            // Footer
            HStack {
                Text("Don't have an account?")
                    .foregroundStyle(Color.secondary)
                Button(action: { viewModel.switchState(to: .signUp) }) {
                    Text("Sign Up")
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
        .alert("Register PassKey", isPresented: $viewModel.dataModel.showPassKeyRegistration) {
            TextField("Enter your name", text: $viewModel.dataModel.passKeyUserName)
            Button("Register") {
                if !viewModel.dataModel.passKeyUserName.isEmpty {
                    viewModel.registerPassKey(userName: viewModel.dataModel.passKeyUserName)
                }
            }
            Button("Cancel", role: .cancel) {
                viewModel.dataModel.showPassKeyRegistration = false
            }
        } message: {
            Text("To sign in with PassKey, you need to register first. Please enter your name to create a PassKey.")
        }
    }
}
