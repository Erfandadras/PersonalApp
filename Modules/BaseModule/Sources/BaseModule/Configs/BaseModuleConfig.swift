//
//  BaseModuleConfig.swift
//  BaseModule
//
//  Created by Erfan mac mini on 11/15/25.
//
import UIKit

public struct BaseModuleConfig {
    /// config all base module related classes
    /// like image cache system
    public static func config(_ app: UIApplication) {
        // load fonts
        UIFont.loadAll()
    }
}
