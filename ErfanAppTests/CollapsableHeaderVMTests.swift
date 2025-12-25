import Testing
import UIKit
import SwiftUI
@testable import ErfanApp

@Suite struct CollapsableHeaderVMTests {
    
    let config = CollapsableHeaderConfig(maxHeight: 200, minHeight: 100, snapThreshold: 0.5, velocityThreshold: 10)
    
    @Test func testInitialState() {
        let vm = CollapsableHeaderVM(config: config)
        #expect(vm.output.height == 200)
        #expect(vm.output.progress == 0)
        #expect(vm.output.state == .expanded)
    }
    
    @Test func testScrollingUpCollapsesHeader() {
        let vm = CollapsableHeaderVM(config: config)
        let scrollView = UIScrollView()
        
        // Simulate scroll up (offset increases)
        scrollView.contentOffset.y = 10
        vm.scrollViewDidScroll(scrollView)
        
        #expect(vm.output.height == 190)
        #expect(vm.output.state == .collapsing)
        #expect(vm.output.consumedScroll == 10)
    }
    
    @Test func testScrollingDownExpandsHeader() {
        let vm = CollapsableHeaderVM(config: config)
        let scrollView = UIScrollView()
        
        // Move to partially collapsed first
        scrollView.contentOffset.y = 50
        vm.scrollViewDidScroll(scrollView)
        #expect(vm.output.height == 150)
        
        // Simulate scroll down (offset decreases)
        scrollView.contentOffset.y = 40
        vm.scrollViewDidScroll(scrollView)
        
        #expect(vm.output.height == 160)
        #expect(vm.output.state == .expanding)
        #expect(vm.output.consumedScroll == -10)
    }
    
    @Test func testVelocitySnapCollapsing() {
        let vm = CollapsableHeaderVM(config: config)
        let scrollView = UIScrollView()
        
        // Scroll up a bit
        scrollView.contentOffset.y = 20
        vm.scrollViewDidScroll(scrollView)
        
        // Simulate dragging end with high velocity UP (should collapse)
        // velocity.y is positive for scrolling up
        vm.scrollViewWillEndDragging(scrollView, withVelocity: CGPoint(x: 0, y: 15), targetContentOffset: .allocate(capacity: 1))
        
        // Current logic: velocityY = velocity.y * -1 = -15
        // shouldCollapse = -15 > 0 -> false
        // EXPECTED: shouldCollapse = true
        #expect(vm.output.state == .collapsed)
    }
    
    @Test func testVelocitySnapExpanding() {
        let vm = CollapsableHeaderVM(config: config)
        let scrollView = UIScrollView()
        
        // Scroll up to collapse it first
        scrollView.contentOffset.y = 100
        vm.scrollViewDidScroll(scrollView)
        #expect(vm.output.state == .collapsed)
        
        // Simulate dragging end with high velocity DOWN (should expand)
        // velocity.y is negative for scrolling down
        vm.scrollViewWillEndDragging(scrollView, withVelocity: CGPoint(x: 0, y: -15), targetContentOffset: .allocate(capacity: 1))
        
        // Current logic: velocityY = velocity.y * -1 = 15
        // shouldCollapse = 15 > 0 -> true (it stays collapsed!)
        // EXPECTED: shouldCollapse = false (it expands)
        #expect(vm.output.state == .expanded)
    }
}
