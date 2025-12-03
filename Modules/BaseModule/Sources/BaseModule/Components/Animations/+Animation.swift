//
//  File.swift
//  BaseModule
//
//  Created by Erfan mac mini on 11/28/25.
//

import Foundation

public struct AnimationData {
    public var shouldStart: Bool
    public var delay: Double
    public var finished: Bool
    public var duration: Double
    
    public init(shouldStart: Bool = false,
         delay: Double = 0,
         finished: Bool = false,
         duration: Double = 0) {
        self.shouldStart = shouldStart
        self.delay = delay
        self.finished = finished
        self.duration = duration
    }
}
