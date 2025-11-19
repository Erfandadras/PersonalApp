//
//  FontLoader.swift
//  BaseModule
//
//  Created by Erfan mac mini on 11/19/25.
//

import UIKit

// MARK: - Load fonts
public extension UIFont {
    private static var loaded = false

    private static let allFonts = [
        "PoppinsLatin-SemiBold.ttf",
        "PoppinsLatin-Regular.ttf",
        "PoppinsLatin-Medium.ttf",
        "PoppinsLatin-Light.ttf",
        "PoppinsLatin-Bold.ttf",
    ]

    static func loadAll() {
        guard !loaded else { return }
        let fontsBundle = Bundle.module
        allFonts.forEach { fontName in
            let parts = fontName.split(separator: ".")
            guard let file = parts.first.map(String.init),
                  let ext = parts.last.map(String.init),
                  let url = fontsBundle.url(forResource: file, withExtension: ext) else { return }
            CTFontManagerRegisterFontsForURL(url as CFURL, CTFontManagerScope.process, nil)
        }
        loaded = true
    }
}
