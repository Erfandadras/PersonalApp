//
//  File.swift
//  BaseModule
//
//  Created by Erfan mac mini on 11/24/25.
//

import Combine

public struct ViewModelState {
    public var loading = true
    public var reloading = false
    public var error: Error? = nil
    public var loadingMore = false
    
    mutating func success() -> Self {
        self.loading = false
        self.reloading = false
        self.error = nil
        self.loadingMore = false
        return self
    }
    
    mutating func failure(error: Error) -> Self {
        self.loading = false
        self.reloading = false
        self.error = error
        self.loadingMore = false
        return self
    }
}

open class BaseViewModel: ObservableObject {
    // MARK: - properties
    @Published public private(set) var state: ViewModelState?
    @Published public private(set) var toast: Toast?
    public var bag: Set<AnyCancellable> = []
    
    public init() {}
    
    // MARK: - logics
    public func updateState(state: ViewModelState) {
        waitMainThread(after: 0.3, callback: {
            self.state = state
        })
    }
    
    public func setupToast(toast: Toast?) {
        self.toast = toast
    }
}
