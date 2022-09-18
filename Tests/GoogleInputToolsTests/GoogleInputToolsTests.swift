@testable import GoogleInputTools
import XCTest

final class GoogleInputToolsTests: XCTestCase {
    func testAppendAndRemoveCharacters() throws {
        let inputTools = GoogleInputTools()

        inputTools.append("a")
        XCTAssertEqual(inputTools.input, "a")
        inputTools.append("b")
        XCTAssertEqual(inputTools.input, "ab")
        inputTools.append("c")
        XCTAssertEqual(inputTools.input, "abc")
        inputTools.popLast()
        XCTAssertEqual(inputTools.input, "ab")
        inputTools.popLast()
        XCTAssertEqual(inputTools.input, "a")
        inputTools.popLast()
        XCTAssertEqual(inputTools.input, "")
        inputTools.popLast()
        XCTAssertEqual(inputTools.input, "")
    }
}
