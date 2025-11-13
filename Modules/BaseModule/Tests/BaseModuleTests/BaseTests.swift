import XCTest
@testable import BaseModule

final class BaseTests: XCTestCase {
    func testBaseHello() throws {
        let base = Base()
        XCTAssertEqual(base.hello(), "Hello from Base module!")
    }
    
    func testDefaultConfiguration() throws {
        let config = DefaultConfiguration()
        XCTAssertEqual(config.appName, "ErfanApp")
        XCTAssertEqual(config.version, "1.0.0")
    }
}

