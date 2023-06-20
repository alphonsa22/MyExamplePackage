import XCTest
@testable import MyExamplePackage

final class MyExamplePackageTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(MyExamplePackage().text, "Hello, World!")
    }
}
