//
//  File.swift
//  BaseModule
//
//  Created by Erfan mac mini on 11/24/25.
//

import SwiftUI
import Combine

public struct ViewModelState {
    public var loading = false
    public var reloading = false
    public var error: Error? = nil
    public var loadingMore = false
    
    public static func setLoading(value: Bool) -> Self {
        return ViewModelState(loading: value)
    }
    
    public static func success() -> Self {
        return ViewModelState(loading: false)
    }
    
    public static func failure(error: Error) -> Self {
        return ViewModelState(loading: false)
    }
}

@MainActor
@Observable
open class BaseViewModel {
    // MARK: - properties
    public private(set) var modelState: ViewModelState = .init()
    public var toast: Toast?
    public var bag: Set<AnyCancellable> = []
    
    public init() {}
    
    // MARK: - logics
    public func updateState(state: ViewModelState) {
        waitMainThread(after: 0.3, callback: {
            self.modelState = state
        })
    }
    
    public func setupToast(toast: Toast?) {
        self.toast = toast
    }
}
