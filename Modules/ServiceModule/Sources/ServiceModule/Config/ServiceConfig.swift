//
//  File.swift
//  ServiceModule
//
//  Created by Erfan mac mini on 11/27/25.
//

import Firebase

public struct ServiceModuleConfig {
    /// config firebase
    public static func config(_ app: UIApplication) {
        FirebaseApp.configure()
    }
}
