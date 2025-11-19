//
//  K.swift
//  realstate
//
//  Created by Erfan mac mini on 11/19/24.
//

import UIKit
import SwiftUI

/// default vertical padding
public let defaultVPadding = 12.updateForHeight()

/// default Horizontal padding
public let defaultHPadding = 12.updateForHeight()

public struct K {
    /// Size
    public struct size {
        ///  base design screen size
        static let designSize = CGSize(width: 430, height: 932)
        /// phone bounds
        public static var bounds = UIScreen.main.bounds
        
        /// portrait size
        public static var portrait: CGSize {
            let width = bounds.width > bounds.height ? bounds.height : bounds.width
            let height = bounds.width > bounds.height ? bounds.width : bounds.height
            return CGSize(width: width, height: height)
        }
        /// landscape size
        public static var landscape: CGSize {
            let width = bounds.width > bounds.height ? bounds.height : bounds.width
            let height = bounds.width > bounds.height ? bounds.width : bounds.height
            return CGSize(width: height, height: width)
        }
    }
    
    /// Metric constants
    public struct MetricData {
        public static let areaUnit: String = "m²"
        public static let priceUnit: String = "$"
        public static let distanceUnit: String = "km"
        public static let currencyCode: String = "USD"
        public static let currencyDecimalDigits: Int = 2
    }
    
    // MARK: - default background style or border styles
    public struct Styles {}
}
