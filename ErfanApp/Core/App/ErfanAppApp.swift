//
//  ErfanAppApp.swift
//  ErfanApp
//
//  Created by Erfan mac mini on 11/13/25.
//

import SwiftUI
import BaseModule

@main
struct ErfanAppApp: App {
    // MARK: - properties
    @MainActor
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    // MARK: - init
    init() {
        UIFont.loadAll()
    }
    
    // MARK: - view
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
