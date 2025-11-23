import XCTest
@testable import BaseModule

final class BaseTests: XCTestCase {
    func testDefaultConfiguration() throws {
        let config = DefaultConfiguration()
        XCTAssertEqual(config.appName, "ErfanApp")
        XCTAssertEqual(config.version, "1.0.0")
    }
}

