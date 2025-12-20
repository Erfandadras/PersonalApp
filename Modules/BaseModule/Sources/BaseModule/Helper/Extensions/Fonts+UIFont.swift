
//
//  Font+Assets.swift
//  SalesGuru
//
//  Created by Erfan mac mini on 6/22/24.
//


import SwiftUI

// MARK: - convert UIFont to Fonts
public extension UIFont {
    func Convert() -> Font {
        return .init(self)
    }
}

public extension Font {
    struct Poppins {
        public static func bold(_ size: CGFloat) -> Font {
            return UIFont(name: "PoppinsLatin-Bold", size: size)!.Convert()
        }
        
        public static func semiBold(_ size: CGFloat) -> Font {
            return UIFont(name: "PoppinsLatin-SemiBold", size: size)!.Convert()
        }
        
        public static func medium(_ size: CGFloat) -> Font {
            return UIFont(name: "PoppinsLatin-Medium", size: size)!.Convert()
        }
        
        public static func regular(_ size: CGFloat) -> Font {
            return UIFont(name: "PoppinsLatin-Regular", size: size)!.Convert()
        }
        
        public static func light(_ size: CGFloat) -> Font {
            return UIFont(name: "PoppinsLatin-Light", size: size)!.Convert()
        }
    }
    
    struct Copperplate {
        public static func Bold(size: CGFloat) -> Font {
            return .custom("Copperplate-Bold", size: size)
        }
    }
    
    struct GillSans {
        public static func Regular(size: CGFloat) -> Font {
            return .custom("GillSans-Regular", size: size)
        }
    }
    
    struct ChalkboardSE {
        public static func Bold(size: CGFloat) -> Font {
            return .custom("ChalkboardSE-Bold", size: size)
        }
        
        public static func Regular(size: CGFloat) -> Font {
            return .custom("ChalkboardSE-Regular", size: size)
        }
    }
    
    static func Naskhi(size: CGFloat) -> Font {
        return .custom("Mj_Naskhi", size: size)
        
    }
}
