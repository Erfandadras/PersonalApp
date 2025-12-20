//
//  CollapsableHeaderView.swift
//  ErfanApp
//

import SwiftUI
import BaseModule

enum ScrollContentType: Int, CaseIterable {
    case green
    case black
    
    var title: String {
        switch self {
        case .green: return "Analytics"
        case .black: return "Reports"
        }
    }
    
    var color: Color {
        switch self {
        case .green: return Color(hex: "00C853")
        case .black: return Color(hex: "212121")
        }
    }
    
    var icon: String {
        switch self {
        case .green: return "chart.bar.fill"
        case .black: return "doc.text.fill"
        }
    }
}

struct CollapsableHeaderView: View {
    // MARK: - Constants
    private let minHeaderHeight: CGFloat = 110
    private let maxHeaderHeight: CGFloat = 300
    
    // MARK: - State Variables
    @State private var currentHeaderHeight: CGFloat = 300
    @State private var scrollType: ScrollContentType = .green
    @State private var changes: CGFloat = 0
    
    // Store scroll offset for each tab separately
    @State private var greenScrollOffset: CGFloat = 0
    @State private var blackScrollOffset: CGFloat = 0
    @State private var lastScrollOffset: CGFloat = 0
    
    var body: some View {
        ZStack(alignment: .top) {
            // MARK: - Background Layer
            Color(UIColor.systemGroupedBackground)
                .ignoresSafeArea()
            // MARK: - Header
            headerView
                .frame(height: currentHeaderHeight)
                .zIndex(2)
            
            tabSelector
                .offset(y: currentHeaderHeight - 25)
                .zIndex(3)
            
            scrollableContent
                .zIndex(1)
            
            
        }
        .ignoresSafeArea(edges: .top)
        .onChange(of: scrollType) { _, newTab in
            // Synchronize lastScrollOffset immediately to prevent jumps in delta calculation
            lastScrollOffset = newTab == .green ? greenScrollOffset : blackScrollOffset
//            let changes = maxHeaderHeight - currentHeaderHeight
//            
//            if newTab == .black {
//                if abs(blackScrollOffset) <= abs(changes) {
//                    self.changes = changes
//                    self.lastScrollOffset = changes
//                    print("set changes", changes)
//                }
//            } else {
//                if abs(greenScrollOffset) <= abs(changes) {
//                    self.changes = changes
//                    self.lastScrollOffset = changes
//                    print("set changes", changes)
//                }
//            }
        }
    }
    
    // MARK: - Premium Header View
    private var headerView: some View {
        let progress = (currentHeaderHeight - minHeaderHeight) / (maxHeaderHeight - minHeaderHeight)
        
        return ZStack {
            // Animated Mesh-like Gradient
            LinearGradient(
                colors: [Color.blue, Color.purple, Color.red],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .hueRotation(.degrees(Double(progress) * 30))
            .overlay(
                Circle()
                    .fill(Color.white.opacity(0.15))
                    .frame(width: 400, height: 400)
                    .blur(radius: 60)
                    .offset(x: -100, y: -100)
            )
            
            // Content
            VStack(spacing: 12) {
                Spacer(minLength: 0)
                
                // Profile/Icon Area
                Image(systemName: "person.crop.circle.fill.badge.checkmark")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 60 + (progress * 40), height: 60 + (progress * 40))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                    .scaleEffect(0.8 + (progress * 0.2))
                    .opacity(0.3 + (progress * 0.7))
                
                VStack(spacing: 4) {
                    Text("Erfan Dadras")
                        .font(.system(size: 20 + (progress * 12), weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text("Premium Developer Interface")
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundColor(.white.opacity(0.8))
                        .opacity(Double(progress))
                        .scaleEffect(progress)
                }
                
                Spacer(minLength: 40)
            }
            .padding(.top, 40)
            .padding(.bottom, 20)
        }
        .clipShape(CustomCorner(corners: [.bottomLeft, .bottomRight], radius: 30 * progress))
        .shadow(color: Color.black.opacity(0.15), radius: 20, x: 0, y: 10)
    }
    
    // MARK: - Glassmorphic Tab Selector
    private var tabSelector: some View {
        HStack(spacing: 15) {
            ForEach(ScrollContentType.allCases, id: \.self) { type in
                Button {
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
                                Capsule()
                                    .fill(Color.white)
                                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 3)
                                    .matchedGeometryEffect(id: "tab", in: tabAnimation)
                            }
                        }
                    )
                    .foregroundColor(scrollType == type ? .black : .white)
                }
            }
        }
        .padding(6)
        .background(.ultraThinMaterial)
        .clipShape(Capsule())
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
        .padding(.horizontal)
    }
    
    @Namespace private var tabAnimation
    
    // MARK: - Scrollable Content
    private var scrollableContent: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                scrollViewContent(type: .green, width: geometry.size.width, coordinateSpace: "greenSpace")
                scrollViewContent(type: .black, width: geometry.size.width, coordinateSpace: "blackSpace")
            }
            .offset(x: -CGFloat(scrollType.rawValue) * geometry.size.width)
        }
        .padding(.top, 40) // Space for the floating tab bar
    }
    
    private func scrollViewContent(type: ScrollContentType,
                                   width: CGFloat,
                                   coordinateSpace: String) -> some View {
        return ScrollView(showsIndicators: false) {
            VStack(spacing: 16) {
//                 Top Spacer for the header area
                Color.clear.frame(height: maxHeaderHeight)
                
                // Featured Card
                FeaturedCard(type: type)
                    .padding(.horizontal)
                
                // List Items
                ForEach(0..<15, id: \.self) { index in
                    ModernContentCard(index: index, type: type)
                }
                
                Color.clear.frame(height: 100)
            }
            .scrollToOffset(contentOffset: .constant(.init(x: 0, y: changes)))
            .trackOffset(completion: { offset in
                handleScrollOffset(offset: offset.y, for: type)
            }, coordinatorSpace: coordinateSpace)
        }
        .coordinateSpace(name: coordinateSpace)
        .frame(width: width)
    }
    
    // MARK: - Logic
    private func handleScrollOffset(offset: CGFloat, for type: ScrollContentType) {
        // 1. Update stored offsets for the specific tab
        if type == .green { greenScrollOffset = offset }
        else { blackScrollOffset = offset }
        
        // 2. Only the active tab should drive the header height
        guard type == scrollType else { return }
        
        // 3. Calculate delta (movement since last update)
        let delta = offset - lastScrollOffset
        
        // 4. Update memory: ALWAYS update lastScrollOffset so deltas stay relative to current position.
        lastScrollOffset = offset
        
        // 5. Calculate candidate height
        let newHeight = currentHeaderHeight + delta
        if newHeight < minHeaderHeight || newHeight > maxHeaderHeight {
            return
        }
        // 6. Only animate if the height actually changes
        if newHeight != currentHeaderHeight {
            withAnimation(.interactiveSpring(response: 0.3, dampingFraction: 0.8)) {
                currentHeaderHeight = newHeight
            }
        }
    }
}

// MARK: - Supporting Views

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
            
            Text("Discover the latest insights and data analytics for your project.")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            RoundedRectangle(cornerRadius: 15)
                .fill(type.color.opacity(0.1))
                .frame(height: 150)
                .overlay(
                    Image(systemName: type.icon)
                        .font(.system(size: 50))
                        .foregroundColor(type.color)
                )
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
    }
}

struct ModernContentCard: View {
    let index: Int
    let type: ScrollContentType
    
    var body: some View {
        HStack(spacing: 15) {
            Circle()
                .fill(type.color.opacity(0.1))
                .frame(width: 50, height: 50)
                .overlay(Text("\(index + 1)").bold().foregroundColor(type.color))
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Data Point Entry \(index + 1)")
                    .font(.headline)
                Text("Last updated 2 hours ago")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption.bold())
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .padding(.horizontal)
    }
}

struct CustomCorner: Shape {
    var corners: UIRectCorner
    var radius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

#Preview {
    CollapsableHeaderView()
}



fileprivate struct ScrollContentOffsetModifier: ViewModifier {
    @Binding var contentOffset: CGPoint

    func body(content: Content) -> some View {
        content
            .background {
                InternalScrollViewHelper(contentOffset: $contentOffset)
            }
    }
}

extension View {
    func scrollToOffset(contentOffset: Binding<CGPoint>) -> some View {
        return modifier(ScrollContentOffsetModifier(contentOffset: contentOffset))
    }
}

fileprivate struct InternalScrollViewHelper: UIViewRepresentable {
    @Binding var contentOffset: CGPoint
    @State private var scrollView: UIScrollView?

    func makeUIView(context: Context) -> some UIView {
        let view = ScrollViewIdentifier()
        view.scrollViewCompletion = { scrollView in
            self.scrollView = scrollView
        }
        return view
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
        scrollView?.setContentOffset(contentOffset, animated: false)
    }
}

fileprivate final class ScrollViewIdentifier: UIView {
    var scrollViewCompletion: ((UIScrollView) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    override func didMoveToWindow() {
        guard let scrollView = superview?.superview?.superview as? UIScrollView else {
            return
        }
        self.scrollViewCompletion?(scrollView)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
