//
//  IntroductionView.swift
//  ErfanApp
//
//  Created by Erfan mac mini on 12/7/25.
//

import SwiftUI
import BaseModule
import Lottie

struct IntroductionView: View {
    // MARK: - Properties
    @StateObject private var viewModel: IntroductionVM
    @State private var showDetail: Bool = false
    @State private var openMenu: Bool = false
    @Environment(\.openURL) private var openURL
    
    // Animation states
    @State private var showInitial: Bool = false
    @State private var showMenuButton: Bool = false
    @State private var showGreeting: Bool = false
    @State private var showName: Bool = false
    @State private var showTitle: Bool = false
    @State private var showSocialButtons: Bool = false
    @State private var personImageScale: CGFloat = 0.8
    @State private var personImageOpacity: Double = 0
    @State private var avatarImage: UIImage?
    
    private var introduction: UserIntroduction? {
        viewModel.introduction
    }
    
    private var isLoading: Bool {
        viewModel.introductionState.loading
    }
    
    // MARK: - Init
    init() {
        _viewModel = .init(wrappedValue: .init())
    }
    
    // MARK: - View
    var body: some View {
        ZStack {
            // Background mesh
            Image(.mesh)
                .resizable()
                .opacity(0.8)
            
            ZStack(alignment: .bottom) {
                // Person image with animation and loading state
                ZStack {
                    if let avatarImage {
                        Image(uiImage: avatarImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(.top, 90)
                            .scaleEffect(personImageScale)
                            .opacity(personImageOpacity)
                    } else if (isLoading || avatarImage == nil) && introduction != nil {
                        // Image skeleton
                        Rectangle()
                            .fill(.white.opacity(0.05))
                            .shimmer()
                            .padding(.top, 90)
                            .scaleEffect(personImageScale)
                            .opacity(personImageOpacity)
                    }
                }
                
                // Gradients
                topGradient()
                bottomGradient()
                
                // Main content
                if isLoading {
                    loadingView()
                } else {
                    contentView()
                }
            }
        }
        .background(.black)
        .ignoresSafeArea()
        .sheet(isPresented: $openMenu, content: {
            CreateUserIntroductionView(introduction)
        })
        .onChange(of: viewModel.introductionState.loading) { _, newValue in
            if !newValue && introduction != nil {
                startAnimations()
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    if introduction != nil {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                            openMenu.toggle()
                        }
                    }
                } label: {
                    LottieSwitch(animation: .named("menuAnimation"))
                        .isOn($openMenu)
                        .onAnimation(fromProgress: 0, toProgress: 1)
                        .offAnimation(fromProgress: 1, toProgress: 0)
                        .configure { animation in
                            animation.animationSpeed = 2.5
                        }
                        .frame(width: 32, height: 32)
                }
                .opacity(showMenuButton ? 1 : 0)
                .offset(x: showMenuButton ? 0 : 50)
            }
        }
        .preferredColorScheme(.dark)
        .task(id: introduction?.avatar) {
            await loadAvatar()
        }
    }
    
    // MARK: - Avatar Loading
    private func loadAvatar() async {
        guard let url = introduction?.getAvatarURL() else {
            avatarImage = nil
            return
        }
        
        // Load in background thread
        let image = await Task.detached {
            UIImage(contentsOfFile: url.path)
        }.value
        
        await MainActor.run {
            withAnimation(.easeIn(duration: 0.5)) {
                self.avatarImage = image
            }
        }
    }
    
    // MARK: - Content View
    @ViewBuilder
    private func contentView() -> some View {
        VStack(spacing: 80) {
            // Header
            Spacer()
            
            // Name and title section
            if let introduction {
                VStack(spacing: 12) {
                    Spacer()
                    
                    Text("Hi, I'm")
                        .font(.ChalkboardSE.Regular(size: 24))
                        .foregroundStyle(.white.opacity(0.8))
                        .opacity(showGreeting ? 1 : 0)
                        .offset(y: showGreeting ? 0 : 20)
                    
                    Text(introduction.firstName.capitalized + " " + introduction.lastName.capitalized)
                        .font(.ChalkboardSE.Bold(size: 32))
                        .foregroundStyle(.white)
                        .opacity(showName ? 1 : 0)
                        .scaleEffect(showName ? 1 : 0.8)
                    
                    Text(introduction.title.capitalized)
                        .font(.ChalkboardSE.Regular(size: 18))
                        .foregroundStyle(.white.opacity(0.7))
                        .opacity(showTitle ? 1 : 0)
                        .offset(y: showTitle ? 0 : 20)
                }
            }
            
            // Social buttons
            HStack(spacing: 32) {
                socialButton(image: .github, index: 0) {
                    if let url = introduction?.githubURL {
                        openURL.callAsFunction(url)
                    }
                }
                
                socialButton(image: .instagram, index: 1) {
                    if let url = introduction?.instagramURL {
                        openURL.callAsFunction(url)
                    }
                }
                
                socialButton(image: .linkedin, index: 2) {
                    if let url = introduction?.linkedinURL {
                        openURL.callAsFunction(url)
                    }
                }
            }
            .opacity(showSocialButtons ? 1 : 0)
            .offset(y: showSocialButtons ? 0 : 30)
        }
        .padding(.bottom, 48)
        .toast(toast: $viewModel.toast)
    }
    
    // MARK: - Social Button
    @ViewBuilder
    private func socialButton(image: ImageResource, index: Int, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(image)
                .resizable()
                .renderingMode(.template)
        }
        .tint(.white)
        .frame(width: 32, height: 32)
        .scaleEffect(showSocialButtons ? 1 : 0.5)
        .animation(
            .spring(response: 0.6, dampingFraction: 0.6)
            .delay(Double(index) * 0.1),
            value: showSocialButtons
        )
    }
    
    // MARK: - Loading View
    @ViewBuilder
    private func loadingView() -> some View {
        VStack(spacing: 80) {
            // Header skeleton
            HStack {
                Circle()
                    .fill(.white.opacity(0.1))
                    .frame(width: 40, height: 40)
                    .shimmer()
                
                Spacer()
                
                RoundedRectangle(cornerRadius: 8)
                    .fill(.white.opacity(0.1))
                    .frame(width: 48, height: 48)
                    .shimmer()
            }
            .padding(.top, 50)
            .padding(.horizontal, 24)
            
            Spacer()
            
            // Name skeleton
            VStack(spacing: 12) {
                Spacer()
                
                RoundedRectangle(cornerRadius: 6)
                    .fill(.white.opacity(0.1))
                    .frame(width: 100, height: 24)
                    .shimmer()
                
                RoundedRectangle(cornerRadius: 8)
                    .fill(.white.opacity(0.1))
                    .frame(width: 200, height: 32)
                    .shimmer()
                
                RoundedRectangle(cornerRadius: 6)
                    .fill(.white.opacity(0.1))
                    .frame(width: 150, height: 18)
                    .shimmer()
            }
            
            // Social buttons skeleton
            HStack(spacing: 32) {
                ForEach(0..<3) { _ in
                    Circle()
                        .fill(.white.opacity(0.1))
                        .frame(width: 32, height: 32)
                        .shimmer()
                }
            }
        }
        .padding(.bottom, 48)
    }
    
    // MARK: - Gradients
    @ViewBuilder
    private func topGradient() -> some View {
        VStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.white.opacity(0.2), .clear]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                
                HStack {
                    LinearGradient(
                        gradient: Gradient(colors: [Color.black.opacity(0.3), .clear]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    
                    LinearGradient(
                        gradient: Gradient(colors: [Color.black.opacity(0.3), .clear]),
                        startPoint: .trailing,
                        endPoint: .leading
                    )
                }
            }
            .frame(height: 250)
            Spacer()
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    @ViewBuilder
    private func bottomGradient() -> some View {
        VStack {
            Spacer()
            LinearGradient(
                colors: [.black, .clear],
                startPoint: .bottom,
                endPoint: .top
            )
            .frame(height: 350)
        }
    }
    
    // MARK: - Animations
    private func startAnimations() {
        // Person image animation
        withAnimation(.spring(response: 0.8, dampingFraction: 0.7)) {
            personImageScale = 1.0
            personImageOpacity = 1.0
        }
        
        // Staggered entrance animations
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.2)) {
            showInitial = true
        }
        
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.3)) {
            showMenuButton = true
        }
        
        withAnimation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.5)) {
            showGreeting = true
        }
        
        withAnimation(.spring(response: 0.7, dampingFraction: 0.6).delay(0.7)) {
            showName = true
        }
        
        withAnimation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.9)) {
            showTitle = true
        }
        
        withAnimation(.spring(response: 0.6, dampingFraction: 0.6).delay(1.1)) {
            showSocialButtons = true
        }
    }
}

// MARK: - Shimmer Effect
extension View {
    func shimmer() -> some View {
        self.modifier(ShimmerModifier())
    }
}

struct ShimmerModifier: ViewModifier {
    @State private var phase: CGFloat = 0
    
    func body(content: Content) -> some View {
        content
            .overlay(
                LinearGradient(
                    gradient: Gradient(colors: [
                        .clear,
                        .white.opacity(0.3),
                        .clear
                    ]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .offset(x: phase)
                .mask(content)
            )
            .onAppear {
                withAnimation(
                    .linear(duration: 1.5)
                    .repeatForever(autoreverses: false)
                ) {
                    phase = 400
                }
            }
    }
}
