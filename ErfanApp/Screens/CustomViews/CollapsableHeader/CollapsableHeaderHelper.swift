//
//  CollapsableHeaderHelper.swift
//  ErfanApp
//
//  Created by Erfan mac mini on 12/22/25.
//

import UIKit
import Combine
import SwiftUI

/// Represents the current visibility state of the collapsible header.
public enum CollapsableHeaderState {
    /// The header is fully collapsed to its minimum height.
    case collapsed
    /// The header is fully expanded to its maximum height.
    case expanded
    /// The header is currently in the process of expanding.
    case expanding
    /// The header is currently in the process of collapsing.
    case collapsing
}

/// Configuration parameters for the `CollapsableHeaderHelper`.
public struct CollapsableHeaderConfig {
    /// The maximum height of the header when fully expanded.
    public let maxHeight: CGFloat
    /// The minimum height of the header when fully collapsed.
    public let minHeight: CGFloat
    /// The threshold (0.0 to 1.0) at which the header snaps to collapsed/expanded state when scrolling ends.
    public let snapThreshold: CGFloat
    /// The velocity threshold required to trigger an automatic snap animation.
    public let velocityThreshold: CGFloat
    /// The intensity of the parallax effect (0.0 to 1.0).
    public let parallaxFactor: CGFloat
    
    /// Initializes a new configuration for the collapsible header.
    /// - Parameters:
    ///   - maxHeight: The maximum height of the header.
    ///   - minHeight: The minimum height of the header.
    ///   - snapThreshold: The progress threshold for snapping (default 0.5).
    ///   - velocityThreshold: The velocity threshold for snapping (default 3).
    ///   - parallaxFactor: The intensity of the parallax effect (default 0.5).
    public init(maxHeight: CGFloat,
                minHeight: CGFloat,
                snapThreshold: CGFloat = 0.5,
                velocityThreshold: CGFloat = 3,
                parallaxFactor: CGFloat = 0.5) {
        self.maxHeight = maxHeight
        self.minHeight = minHeight
        self.snapThreshold = snapThreshold
        self.velocityThreshold = velocityThreshold
        self.parallaxFactor = parallaxFactor
    }
}

/// The calculated output state of the collapsible header, intended to be consumed by the UI.
public struct CollapsableHeaderOutput {
    /// The current calculated height of the header.
    public let height: CGFloat
    /// The normalized progress of the header expansion (1.0 = expanded, 0.0 = collapsed).
    public let progress: CGFloat
    /// The amount of scroll distance consumed by the header mutation in the current frame.
    public let consumedScroll: CGFloat
    /// The calculated parallax offset for internal header elements.
    public let parallaxOffset: CGFloat
    /// The current operational state of the header.
    public let state: CollapsableHeaderState
}

/// A specialized helper that manages collapsible header logic by intercepting scroll events.
///
/// `CollapsableHeaderHelper` implements `UIScrollViewDelegate` to monitor scroll movements
/// and calculate header transitions. It provides a `@Published` output that SwiftUI views
/// can observe to update their layout dynamically.
///
/// Features:
/// - Smooth interpolation between max and min heights.
/// - Snap-to-state animations based on velocity and position.
/// - Support for top and bottom bounce handling to prevent jitter.
/// - Multi-scrollview coordination via ID tracking.
public final class CollapsableHeaderHelper: NSObject, ObservableObject {
    private let config: CollapsableHeaderConfig
    private var currentHeight: CGFloat
    private var currentState: CollapsableHeaderState = .expanded
    private var activeScrollViewID: ObjectIdentifier?
    
    /// The current state of the header, published for SwiftUI observation.
    @Published public private(set) var output: CollapsableHeaderOutput
    
    private var lastScrollOffset: CGFloat? = nil
    private var isSnapping: Bool = false
    private var lastSnappingOffset: CGFloat = 0
    
    // MARK: - Initialization
    
    /// Creates a new instance of the collapsible header helper.
    /// - Parameter config: The configuration defining the header's behavior and dimensions.
    public init(config: CollapsableHeaderConfig) {
        self.config = config
        self.currentHeight = config.maxHeight
        self.output = .init(height: config.maxHeight,
                            progress: 1,
                            consumedScroll: 0,
                            parallaxOffset: 0,
                            state: .expanded)
    }
    
    // MARK: - Private Logic
    
    /// Processes a scroll event from a scroll view to update header state.
    /// - Parameter scrollView: The scroll view that generated the event.
    private func processScroll(in scrollView: UIScrollView) {
        if isSnapping { return }
        
        let offsetY = scrollView.contentOffset.y
        let insetTop = scrollView.adjustedContentInset.top
        
        // 1. Handle Top Bounce
        // When pulling down at the top, lock the header to expanded state.
        if offsetY <= -insetTop {
            if currentState == .collapsed {
                snappingDown(offset: offsetY)
                return
            }
            let wasHeight = currentHeight
            currentHeight = config.maxHeight
            currentState = .expanded
            lastScrollOffset = offsetY
            withAnimation(.easeInOut(duration: 0.35)) {
                makeOutput(consumedScroll: wasHeight - config.maxHeight)
            }
            return
        }
        
        // 2. Handle Bottom Bounce
        // When pulling up at the very bottom, prevent header mutations to avoid jitter.
        let contentHeight = scrollView.contentSize.height
        let boundsHeight = scrollView.bounds.height
        let insetBottom = scrollView.adjustedContentInset.bottom
        let maxOffset = max(0, contentHeight - boundsHeight + insetBottom)
        
        if offsetY >= maxOffset {
            lastScrollOffset = offsetY
            makeOutput(consumedScroll: 0)
            return
        }

        // 3. Standard Delta Processing
        // Use optional to detect first scroll movement reliably.
        let deltaY = offsetY - (lastScrollOffset ?? offsetY)
        lastScrollOffset = offsetY
        
        var consumedScroll: CGFloat = 0
        
        if deltaY > 0 {
            // User is scrolling up (content moving up) -> Collapse header.
            if currentHeight > config.minHeight {
                let collapseAmount = min(deltaY, currentHeight - config.minHeight)
                currentHeight -= collapseAmount
                consumedScroll = collapseAmount
                currentState = .collapsing
            }
        } else if deltaY < 0 {
            // User is scrolling down (content moving down) -> Expand header.
            if currentHeight < config.maxHeight {
                let expandAmount = min(-deltaY, config.maxHeight - currentHeight)
                currentHeight += expandAmount
                consumedScroll = -expandAmount
                currentState = .expanding
            }
        }
        
        // 4. Resolve Height & State
        currentHeight = clamp(currentHeight,
                              min: config.minHeight,
                              max: config.maxHeight)
        
        if currentHeight <= config.minHeight {
            currentState = .collapsed
        } else if currentHeight >= config.maxHeight {
            currentState = .expanded
        }
        
        makeOutput(consumedScroll: consumedScroll)
    }
    
    /// Generates and publishes the current header output.
    /// - Parameter consumedScroll: The amount of scroll consumed in this update.
    private func makeOutput(consumedScroll: CGFloat){
        let range = Swift.max(0.01, config.maxHeight - config.minHeight)
        let progress = 1 - ((config.maxHeight - currentHeight) / range)
        
        let parallaxOffset = progress * (config.maxHeight - config.minHeight) * config.parallaxFactor
        self.output = CollapsableHeaderOutput(
            height: currentHeight,
            progress: progress,
            consumedScroll: consumedScroll,
            parallaxOffset: parallaxOffset,
            state: currentState
        )
    }
    
    /// Handles specific logic for manual snapping when pulling down.
    private func snappingDown(offset: CGFloat) {
        var delta = lastSnappingOffset - offset
        lastSnappingOffset = offset
        
        if delta < 0 { return }
        
        var consumedScroll = CGFloat(0)
        if currentHeight < config.maxHeight {
            if currentHeight < config.maxHeight * 0.6 && currentHeight > config.maxHeight * 0.35 {
                delta *= 0.5
            }
            let expandAmount = min(delta, config.maxHeight - currentHeight)
            currentHeight += expandAmount
            consumedScroll = -expandAmount
        }
        
        currentHeight = clamp(currentHeight,
                              min: config.minHeight,
                              max: config.maxHeight)
        
        if currentHeight < config.maxHeight * 0.6 {
            makeOutput(consumedScroll: consumedScroll)
        } else {
            currentState = .expanding
        }
    }
    
    /// Performs a snap animation to the nearest valid state based on current progress.
    private func handleScrollEnd() {
        let range = Swift.max(0.01, config.maxHeight - config.minHeight)
        let progress = (config.maxHeight - currentHeight) / range

        let shouldCollapse = progress > config.snapThreshold
        currentHeight = shouldCollapse
        ? config.minHeight
        : config.maxHeight

        currentState = shouldCollapse ? .collapsed : .expanded
        withAnimation(.easeInOut(duration: 0.3)) {
            makeOutput(consumedScroll: 0)
        }
    }
    
    /// Evaluates scroll velocity to determine if an automatic snap should occur.
    /// - Parameter velocityY: The vertical scroll velocity.
    /// - Returns: A boolean indicating if the state was updated via a high-velocity snap.
    private func snapVelocity(velocityY: CGFloat) -> Bool {
        guard abs(velocityY) > config.velocityThreshold else { return false}
        let shouldCollapse = velocityY > 0
        
        currentHeight = shouldCollapse
        ? config.minHeight
        : config.maxHeight
        let newState: CollapsableHeaderState = shouldCollapse ? .collapsed : .expanded
        let stateChanged: Bool
        if currentState == .expanded {
            stateChanged = newState != .expanded
        } else if currentState == .collapsed {
            stateChanged = newState != .expanded
        } else {
            stateChanged = false
        }
        currentState = newState
        
        isSnapping = true
        withAnimation(.easeInOut(duration: 0.3)) {
            makeOutput(consumedScroll: 0)
        }
        
        // Reset snapping flag after animation duration
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
            self.isSnapping = false
        }
        
        return stateChanged
    }
    
    private func clamp(_ v: CGFloat, min: CGFloat, max: CGFloat) -> CGFloat {
        Swift.max(min, Swift.min(max, v))
    }
}

// MARK: - UIScrollViewDelegate Implementation

extension CollapsableHeaderHelper: UIScrollViewDelegate {
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isSnapping = false
        let currentID = ObjectIdentifier(scrollView)
        if activeScrollViewID != currentID {
            activeScrollViewID = currentID
            lastScrollOffset = scrollView.contentOffset.y
        }
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        processScroll(in: scrollView)
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            handleScrollEnd()
        }
    }
    
    public func scrollViewWillEndDragging(
        _ scrollView: UIScrollView,
        withVelocity velocity: CGPoint,
        targetContentOffset: UnsafeMutablePointer<CGPoint>
    ) {
        let stateUpdated = snapVelocity(velocityY: velocity.y)
        var target = targetContentOffset.pointee.y
        if stateUpdated {
            targetContentOffset.pointee.y = scrollView.contentOffset.y
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                if target > scrollView.contentSize.height {
                    target = scrollView.contentSize.height
                }
                scrollView.setContentOffset(.init(x: 0, y: target), animated: true)
            }
        }
    }
}
