//
//  Defines.swift
//  realstate
//
//  Created by Erfan mac mini on 12/9/24.
//

import Foundation

public typealias Action = (() -> Void)
public typealias Success = ((Bool) -> Void)
public typealias Fuccess = ((Error) -> Void)

public func mainThread(callback: @escaping Action) {
    DispatchQueue.main.async {
        callback()
    }
}

public func waitMainThread(after: TimeInterval, callback: @escaping Action) {
    DispatchQueue.main.asyncAfter(deadline: .now() + after) {
        callback()
    }
}
