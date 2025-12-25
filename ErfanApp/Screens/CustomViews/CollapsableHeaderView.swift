//
//  CollapsableHeaderView.swift
//  InterfaceShowcase
//
//  Created for a high-performance, premium UI experience.
//  This view demonstrates a fluid collapsible header synchronized with multiple scroll views,
//  featuring glassmorphism, spring-based animations, and dynamic mesh gradients.
//

import SwiftUI
import BaseModule

/// Defines the themes and content types available for the scrollable areas.
enum ScrollContentType: Int, CaseIterable {
    case analytics
    case reports
    
    /// User-facing title for the segment.
    var title: String {
        switch self {
        case .analytics: return "Insights"
        case .reports: return "Activity"
        }
    }
    
    /// Theme color used for accents and background highlights.
    var color: Color {
        switch self {
        case .analytics: return Color(hex: "6366F1") // Indigo
        case .reports: return Color(hex: "F43F5E")   // Rose
        }
    }
    
    /// SF Symbol name representing the content type.
    var icon: String {
        switch self {
        case .analytics: return "chart.xyaxis.line"
        case .reports: return "bolt.fill"
        }
    }
}

struct CollapsableHeaderView: View {
    // MARK: - Configuration Constants
    @State private var scrollType: ScrollContentType = .analytics
    @StateObject private var headerHelper: CollapsableHeaderHelper
    
    // MARK: - init
    init() {
        _headerHelper = .init(wrappedValue: .init(config: .init(maxHeight: 300, minHeight: 90)))
    }
    
    // MARK: - view
    var body: some View {
        ZStack(alignment: .top){
        VStack(spacing: 0) {
                // MARK: - Header
                headerView
                .frame(height: headerHelper.output.height)
                    .zIndex(2)
                
                scrollableContent
                    .zIndex(1)
            }
            tabSelector
                .offset(y: headerHelper.output.height - 25)
                .zIndex(3)
            
        }
        .background {
            Color(UIColor.systemGroupedBackground)
                .ignoresSafeArea()
        }
        .ignoresSafeArea(edges: .top)
    }
    
    /// A premium header view that reacts to scroll progress.
    /// Features:
    /// - Dynamic mesh gradient that shifts with scroll.
    /// - Scaling and fading typography based on 'progress'.
    /// - Corner radius smoothing for a fluid transition.
    private var headerView: some View {
        // Calculate a 0.0 to 1.0 progress value for animation interpolation
        let progress = headerHelper.output.progress
        let shouldHide = progress < 0.6
        
        return ZStack {
            // Premium Gradient Background with interactive hue rotation
            LinearGradient(
                colors: [
                    Color(hex: "4F46E5"), // Indigo
                    Color(hex: "7C3AED"), // Purple
                    Color(hex: "C026D3")  // Fuchsia
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .hueRotation(.degrees(Double(progress) * 45))
            .overlay {
                // Subtle organic blurred shapes that move slightly with scroll progress
                Circle()
                    .fill(Color.white.opacity(0.12))
                    .blur(radius: 60)
                    .offset(x: -150 * progress, y: -100)
                
                Circle()
                    .fill(Color.blue.opacity(0.1))
                    .blur(radius: 50)
                    .offset(x: 150 * progress, y: 150)
            }
            
            // Header Content Container
            VStack(spacing: 16) {
                Spacer(minLength: 0)
                
                // Animated Avatar/Icon Area with scaling and spring physics
                ZStack {
                    Circle()
                        .fill(.white.opacity(0.2))
                        .frame(width: 70 + (progress * 50),
                               height: 70 + (progress * 50))
                        .blur(radius: 10 * progress)
                    
                    Image(systemName: "cpu.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 35 + (progress * 35), height: 35 + (progress * 35))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                }
                .scaleEffect(0.9 + (progress * 0.1))
                .animation(.spring(response: 0.5, dampingFraction: 0.7), value: progress)
                
                // Ttitle and Status Badge
                VStack(spacing: 4) {
                    Text("Systems Architect")
                        .font(.system(size: 22 + (progress * 10), weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    HStack(spacing: 6) {
                        Circle()
                            .fill(Color.green)
                            .frame(width: 8, height: 8)
                        Text("Active Development")
                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                    }
                    .foregroundColor(.white.opacity(0.9))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(.white.opacity(0.15))
                    .clipShape(Capsule())
                    .opacity(Double(progress))
                    .scaleEffect(progress)
                }
                
                Spacer(minLength: 0)
            }
            .opacity(shouldHide ? 0 : 1)
            .animation(.bouncy, value: shouldHide)
        }
        .cornerRadius(35 * progress, corners: [.bottomLeft, .bottomRight])
        .shadow(color: Color.black.opacity(0.12), radius: 25, x: 0, y: 15)
    }
    
    /// A glassmorphic tab selector that floats over the header boundary.
    private var tabSelector: some View {
        HStack(spacing: 15) {
            ForEach(ScrollContentType.allCases, id: \.self) { type in
                Button {
                    // Provide haptic feedback for tab changes
                    let impact = UIImpactFeedbackGenerator(style: .medium)
                    impact.impactOccurred()
                    
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                        scrollType = type
                    }
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: type.icon)
                            .font(.system(size: 14, weight: .bold))
                        
                        Text(type.title)
                            .font(.system(size: 15, weight: .bold, design: .rounded))
                    }
                    .padding(.vertical, 12)
                    .padding(.horizontal, 20)
                    .background(
                        ZStack {
                            if scrollType == type {
                                // Animated selection highlight with MatchedGeometry
                                Capsule()
                                    .fill(Color.white)
                                    .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 4)
                                    .matchedGeometryEffect(id: "tab", in: tabAnimation)
                            }
                        }
                    )
                    .foregroundColor(scrollType == type ? Color(hex: "4F46E5") : .white)
                }
            }
        }
        .padding(6)
        .background(.ultraThinMaterial)
        .clipShape(Capsule())
        .padding(.horizontal)
    }
    
    @Namespace private var tabAnimation
    
    /// The main scroll view container with horizontal paging for segments.
    private var scrollableContent: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                scrollViewContent(type: .analytics, width: geometry.size.width, coordinateSpace: "analyticsSpace")
                scrollViewContent(type: .reports, width: geometry.size.width, coordinateSpace: "reportsSpace")
            }
            .offset(x: -CGFloat(scrollType.rawValue) * geometry.size.width)
        }
        .padding(.top, 40) // Clearance for the floating tab bar
    }
    
    /// Generates a themed scroll view for a specific content type.
    private func scrollViewContent(type: ScrollContentType,
                                   width: CGFloat,
                                   coordinateSpace: String) -> some View {
        return MainScrollView(delegate: headerHelper) {
            VStack(spacing: 16) {
                // Top padding to prevent content from starting behind the header
                Color.clear.frame(height: 10)
                
                // Featured Card at the top of the list
                FeaturedCard(type: type)
                    .padding(.horizontal)
                
                // Use LazyVStack for efficient rendering of list items
                LazyVStack {
                    ForEach(0..<15, id: \.self) { index in
                        ModernContentCard(index: index, type: type)
                    }
                }
                
                // Bottom spacing for clearance
                Color.clear.frame(height: 100)
            }
        }
        .coordinateSpace(name: coordinateSpace)
        .frame(width: width)
    }
}

// MARK: - Supporting Views

/// A visually engaging card used for featured insights.
struct FeaturedCard: View {
    var type: ScrollContentType
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Featured \(type.title)")
                    .font(.title3.bold())
                Spacer()
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
            }
            
            Text("Explore the latest performance metrics and system health checks.")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            // Visual accent area with icon and simulated chart data
            RoundedRectangle(cornerRadius: 15)
                .fill(type.color.opacity(0.1))
                .frame(height: 150)
                .overlay(
                    VStack(spacing: 15) {
                        Image(systemName: type.icon)
                            .font(.system(size: 44))
                            .foregroundColor(type.color)
                        
                        // Mini Analytics Chart Simulation using randomized heights
                        HStack(alignment: .bottom, spacing: 5) {
                            ForEach(0..<10) { _ in
                                RoundedRectangle(cornerRadius: 2)
                                    .fill(type.color.opacity(0.3))
                                    .frame(width: 8, height: CGFloat.random(in: 10...40))
                            }
                        }
                    }
                )
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
    }
}

/// A standard list item card following modern UI principles.
struct ModernContentCard: View {
    let index: Int
    let type: ScrollContentType
    
    var body: some View {
        HStack(spacing: 15) {
            // Index badge with themed background
            Circle()
                .fill(type.color.opacity(0.1))
                .frame(width: 50, height: 50)
                .overlay(Text("\(index + 1)").bold().foregroundColor(type.color))
            
            VStack(alignment: .leading, spacing: 4) {
                Text("System Performance Log \(index + 1)")
                    .font(.headline)
                Text("Monitored successfully • \(index + 1)m ago")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption.bold())
                .foregroundColor(.secondary)
        }
        .padding()
        .background(.ui.white)
        .cornerRadius(16)
        .padding(.horizontal)
    }
}



#Preview {
    CollapsableHeaderView()
}
