//
//  TextStyle.swift
//  BaseModule
//
//  Created by Erfan mac mini on 11/19/25.
//

import SwiftUI

public extension Font {
    static var ui: LocalTextStyle.Type { LocalTextStyle.self}
}

public struct LocalTextStyle {
    /// extra smal semi bold 10
    public static let xsSemiBold = Font.Poppins.semiBold(10.updateForHeight())
    
    /// smal semi bold 12
    public static let sSemiBold = Font.Poppins.semiBold(12.updateForHeight())
    
    /// smal regular 12
    public static let sRegular = Font.Poppins.regular(12.updateForHeight())
    
    /// one liner regular 14
    public static let mRegular = Font.Poppins.regular(14.updateForHeight())
    
    /// one liner semi bold 14
    public static let mSemiBold = Font.Poppins.semiBold(14.updateForHeight())

    /// New Tag Button Style - Poppins semibold 13
    public static let smSemiBold = Font.Poppins.semiBold(13.updateForHeight())
    
    /// body regular
    public static let bodyRegular = Font.Poppins.regular(14.updateForHeight())
    
    /// section inner title semi bold 16
    public static let largSemiBold = Font.Poppins.semiBold(16.updateForHeight())
    
    /// section inner title semi bold 16
    public static let largeMedium = Font.Poppins.medium(16.updateForHeight())
    
    /// section title semi bold 18
    public static let xlargSemiBold = Font.Poppins.semiBold(18.updateForHeight())
    
    /// screen title semi bold 20
    public static let xxlargSemiBold = Font.Poppins.semiBold(20.updateForHeight())
    
    /// screen title bold 24
    public static let xxxlargBold = Font.Poppins.bold(24.updateForHeight())
}
