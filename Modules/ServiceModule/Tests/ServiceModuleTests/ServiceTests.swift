import XCTest
@testable import ServiceModule
import BaseModule

final class ServiceTests: XCTestCase {
    func testServiceHello() throws {
        let service = Service()
        XCTAssertEqual(service.hello(), "Hello from Service module with Firebase!")
    }
    
    func testGetAppInfo() throws {
        let config = DefaultConfiguration(appName: "TestApp", version: "2.0.0")
        let service = Service(configuration: config)
        XCTAssertEqual(service.getAppInfo(), "App: TestApp, Version: 2.0.0")
    }
    
    func testDataService() async throws {
        let dataService = DataService()
        let data = try await dataService.fetchData()
        XCTAssertNotNil(data)
    }
}

