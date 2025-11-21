//
//  LocalizationManagerTests.swift
//  BaseModuleTests
//
//  Created by ChatGPT on 11/21/25.
//

import XCTest
@testable import BaseModule

final class LocalizationManagerTests: XCTestCase {
    func testSwitchingLanguageChangesLocalizedStrings() {
        let manager = LocalizationManager(userManager: .init())
        manager.setLanguage(.arabic)
        sleep(2)
        XCTAssertEqual(L.Common.hello, "أهلاً")
    }
    
    func testENLanguage() {
        let manager = LocalizationManager(userManager: .init())
        manager.setLanguage(.english)
        sleep(2)
        XCTAssertEqual(L.Common.hello, "Hello")
    }
}

