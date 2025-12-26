//
//  AppState.swift
//  ErfanApp
//
//  Created by Erfan mac mini on 11/28/25.
//

import SwiftUI

enum AppFlow {
    case splash
    case home
    case login
}

@Observable
final class AppState {
    private(set) var flow: AppFlow = .home
    
    func setFlow(_ flow: AppFlow) {
        self.flow = flow
    }
}
