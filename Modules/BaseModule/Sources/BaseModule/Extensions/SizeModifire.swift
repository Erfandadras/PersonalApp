//
//  SizeModifire.swift
//  CommonModule
//
//  Created by Erfan mac mini on 1/27/25.
//

import UIKit

public extension Int {
    func updateForHeight() -> CGFloat {
//        return CGFloat(self)
        let height = K.size.portrait.height
        let designHeight = K.size.designSize.height
        return CGFloat(self) * (height / designHeight)
    }
    
    func updateForWidth() -> CGFloat {
//        return CGFloat(self)
        let width = K.size.portrait.width
        let designWidth = K.size.designSize.width
        return CGFloat(self) * (width / designWidth)
    }
}


public extension CGFloat {
    func updateForHeight() -> CGFloat {
//        return self
        let height = K.size.portrait.height
        let designHeight = K.size.designSize.height
        return self * (height / designHeight)
    }
    
    func updateForWidth() -> CGFloat {
//        return self
        let width = K.size.portrait.width
        let designWidth = K.size.designSize.width
        return self * (width / designWidth)
    }
}
