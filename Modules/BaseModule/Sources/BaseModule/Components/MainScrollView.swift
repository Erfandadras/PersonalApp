//
//  MainScrollView.swift
//  Football360
//
//  Created by Mohammad Razipour on 1/2/23.
//

import SwiftUI
import SwiftUIIntrospect

struct OffsetPreferenceKey: PreferenceKey {
    static let defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value += nextValue()
    }
}

public struct MainScrollView<Content: View>: View {
    
    @ViewBuilder let content: () -> Content
    
    @Binding private var isProgressVisible: Bool
    @Binding private var shouldScrollToTop: Bool
    @Binding private var targetScrollID: Int?
    @State private var isRefreshing = false
    
    private let axes: Axis.Set
    private let showsIndicators: Bool
    private let keyboardDismissMode: UIScrollView.KeyboardDismissMode
    private let onRefresh: (()-> ())?
    private var refreshHelper: RefreshHelper? = nil
    weak private var scrollViewDelegate: UIScrollViewDelegate? = nil
    
    public init(
        axes: Axis.Set = .vertical,
        showsIndicators: Bool = false,
        keyboardDismissMode: UIScrollView.KeyboardDismissMode = .interactive,
        isProgressVisible: Binding<Bool> = .constant(false),
        shouldScrollToTop: Binding<Bool> = .constant(false),
        targetScrollID: Binding<Int?> = .constant(nil),
        delegate: UIScrollViewDelegate? = nil,
        @ViewBuilder content: @escaping () -> Content,
        onRefresh: (() -> Void)? = nil,
    ) {
        self.axes = axes
        self.showsIndicators = showsIndicators
        self.keyboardDismissMode = keyboardDismissMode
        self._isProgressVisible = isProgressVisible
        self._shouldScrollToTop = shouldScrollToTop
        self._targetScrollID = targetScrollID
        self.content = content
        self.onRefresh = onRefresh
        self.scrollViewDelegate = delegate
        
        if #available(iOS 16.0, *) {
            self.refreshHelper = nil
        } else if onRefresh != nil {
            self.refreshHelper = .init(onRefresh: onRefreshHandler)
        }
    }
    
    private var showProgressView: Bool {
        if isRefreshing {
            return false
        } else {
            return isProgressVisible
        }
    }
    
    public var body: some View {
        ZStack {
            if showProgressView {
                ProgressView()
                    .progressViewStyle(.circular)
            }
            
            if onRefresh != nil {
                if #available(iOS 16.0, *) {
                    scrollView()
                        .refreshable {
                            onRefreshHandler()
                        }
                } else {
                    scrollView()
                        .introspect(.scrollView, on: .iOS(.v15, .v16, .v17, .v18, .v26)) { scrollView in
                            if let refreshHelper = refreshHelper {
                                scrollView.refreshControl = refreshHelper.refreshControl
                            }
                        }
                }
                
            } else {
                scrollView()
            }
        }
        .introspect(.scrollView, on: .iOS(.v15, .v16, .v17, .v18, .v26)) { scrollView in
            scrollView.delegate = scrollViewDelegate
            scrollView.keyboardDismissMode = keyboardDismissMode
        }
    }
    
}

extension MainScrollView {
    
    private func scrollView()-> some View {
        ScrollView(axes, showsIndicators: showsIndicators) {
            content()
        }
    }
    
    private func onRefreshHandler() {
        guard let onRefresh = onRefresh else {
            return
        }
        isRefreshing = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            onRefresh()
        }
    }
    
    private class RefreshHelper {
        private(set) var refreshControl: UIRefreshControl
        private var onRefresh: (()-> ())
        
        @MainActor
        init(onRefresh: @escaping (()-> ())) {
            self.onRefresh = onRefresh
            self.refreshControl = .init()
            refreshControl.addTarget(self, action: #selector(didRefresh), for: .valueChanged)
        }
        
        @MainActor @objc private func didRefresh() {
            self.onRefresh()
            refreshControl.endRefreshing()
        }
    }
    
}
