//
//  Coordinator.swift
//  BaseModule
//
//  Created by Erfan mac mini on 12/3/25.
//


import Combine
import SwiftUI

@Observable
public class Coordinator{
    // MARK: - properties
    public var navigationPath = NavigationPath()
    
    // MARK: - init
    public init() {}
    
    // MARK: - logics
    public func append<T>(_ path: T) where T : Hashable {
        navigationPath.append(path)
    }
    
    public func pop() {
        guard !navigationPath.isEmpty else { return }
        navigationPath.removeLast()
    }
    
    public func popToRoot() {
        navigationPath.removeLast(navigationPath.count)
    }
    
    public func popTo(count: Int) {
        if navigationPath.count > count {
            navigationPath.removeLast(count)
        } else {
            popToRoot()
        }
    }
    
    public func switchRootTo<T>(_ path: T) where T : Hashable {
        navigationPath.removeLast(navigationPath.count)
        navigationPath.append(path)
    }
    
}
