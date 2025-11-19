//
//  CoreDependence.swift
//  BaseModule
//
//  Created by Erfan mac mini on 11/15/25.
//

import UIKit

public class CoreDependence: DependenceProviders {
    // MARK: - properties
    // make sure this class execute on the start
    var application: UIApplication?
    private let container = DependencyContainer.shared
    
    // MARK: - init
    init(_ app: UIApplication) {}

    // MARK: - logic
    public func execute() {
        let userManager = UserManager()
        container.register(userManager, for: UserManager.self)
    }
    
    public func reset() {
        @Injected var userManager: UserManager
        userManager.deleteUser()
        container.reset()
    }
}
