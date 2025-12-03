//
//  SplashView.swift
//  ErfanApp
//
//  Created by Erfan mac mini on 11/26/25.
//

import SwiftUI
import BaseModule

struct SplashView: View {
    // MARK: - properties
    @Environment(AppState.self) var appState
    @State var viewModel: SplashViewModel
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0
    @State private var rotationAngle: Double = 0
    @State private var bouncingAnimation = AnimationData(delay: 0.3)
    @State private var trackTextAnimation = AnimationData(delay: 0.3)
    
    // Exit animation states
    @State private var iconOffset: CGFloat = 0
    @State private var appNameOffset: CGFloat = 0
    @State private var welcomeTextOffset: CGFloat = 0
    @State private var progressBarOffset: CGFloat = 0
    @State private var exitOpacity: Double = 1.0
    
    // MARK: - init
    init() {
        self._viewModel = .init(initialValue: .init())
    }
    
    // MARK: - view
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [
                    Color.ui.black.opacity(0.8),
                    Color.ui.black,
                    Color.ui.black.opacity(0.8),
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // Animated circles in background
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.1))
                    .frame(width: 300, height: 300)
                    .offset(x: -100, y: -200)
                    .blur(radius: 20)
                
                Circle()
                    .fill(Color.white.opacity(0.08))
                    .frame(width: 400, height: 400)
                    .offset(x: 150, y: 250)
                    .blur(radius: 30)
            }
            .rotationEffect(.degrees(rotationAngle))
            
            // Main content
            VStack(spacing: 30) {
                // App icon/logo
                ZStack {
                    // Outer glow ring
                    Circle()
                        .stroke(
                            LinearGradient(
                                colors: [Color.white.opacity(0.6), Color.white.opacity(0.2)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 4
                        )
                        .frame(width: 140, height: 140)
                        .blur(radius: 3)
                    
                    // App icon
                    Image(systemName: "cube.box.fill")
                        .font(.system(size: 80))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.white, Color.white.opacity(0.9)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                }
                .scaleEffect(scale)
                .opacity(opacity * exitOpacity)
                .offset(y: iconOffset)
                
                // App name with cascade animation
                VStack(spacing: 12) {
                    BouncingTextView(
                        text: "Comprehensive App",
                        font: .ui.xxxlargBold,
                        color: .white,
                        animationData: $bouncingAnimation
                    )
                    .opacity(exitOpacity)
                    .offset(x: appNameOffset)
                    
                    TrackingTextView(
                        text: "Welcome Back",
                        font: .ui.largeMedium,
                        color: .white.opacity(0.8),
                        animationData: $trackTextAnimation
                    )
                    .opacity(exitOpacity)
                    .offset(x: welcomeTextOffset)
                }
                
                // Loading indicator
                if trackTextAnimation.finished {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.2)
                        .opacity(opacity * 0.8 * exitOpacity)
                        .offset(y: progressBarOffset)
                        .padding(.top, 20)
                }
            }
        }
        .animation(.easeInOut, value: trackTextAnimation.finished)
        .onAppear {
            startAnimationSequence()
            viewModel.checkAuthStatus()
        }
        .onChange(of: bouncingAnimation.finished) { _, newValue in
            if newValue {
                trackTextAnimation.shouldStart = true
            }
        }
        .onChange(of: trackTextAnimation.finished) { _, newValue in
            if newValue {
                DispatchQueue.main.async {
                    withAnimation(.linear(duration: 20).repeatForever(autoreverses: false)) {
                        rotationAngle = 360
                    }
                }
                waitMainThread(after: 1) {
                    viewModel.animationCompleted = true
                }
            }
        }
        .onChange(of: viewModel.appFlow) { _, newValue in
            if newValue != .splash {
                startExitAnimation()
                waitMainThread(after: 2) {
                    appState.setFlow(newValue)
                }
            }
        }
    }
    
    // MARK: - Animation Sequence
    private func startAnimationSequence() {
        // Step 1: Entrance (Logo scale & fade) - Duration: 1.5s
        withAnimation(.spring(response: 1.5, dampingFraction: 0.8)) {
            scale = 1.1
            opacity = 1.0
        } completion: {
            bouncingAnimation.shouldStart = true
        }
    }
    
    // MARK: - Exit Animation
    private func startExitAnimation() {
        withAnimation(.spring(response: 1.8, dampingFraction: 0.8)) {
            // Move icon up
            iconOffset = -200
            
            // Move app name left
            appNameOffset = -400
            
            // Move welcome text right
            welcomeTextOffset = 400
            
            // Move progress bar down
            progressBarOffset = 200
            
            // Fade all elements
            exitOpacity = 0
        }
    }
}
