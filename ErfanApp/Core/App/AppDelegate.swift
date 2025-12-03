//
//  AppDelegate.swift
//  ErfanApp
//
//  Created by Erfan mac mini on 11/15/25.
//

import UIKit
import BaseModule
import ServiceModule

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        print("did launch")
        BaseModuleConfig.config(application)
        ServiceModuleConfig.config(application)
        return true
    }
}
