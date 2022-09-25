@testable import GoogleInputTools
import XCTest

final class GoogleInputServiceTests: XCTestCase {
    func testSendSingleCharacter() throws {
        let expectation = XCTestExpectation(description: "Send a single character to Google Input Tools service")

        let service = GoogleInputService(app: "粵語拼音")
        service.send(currentWord: "", input: "a") { result in
            switch result {
            case let .success(response):
                XCTAssertNotNil(response, "Expected to get a valid response.")
                XCTAssertEqual(response.status, GoogleInputResponse.Status.success, "Unexpected response status.")
                XCTAssertEqual(response.input, "a", "Unexpected input.")
                XCTAssertGreaterThan(response.suggestions.count, 0)
                XCTAssertEqual(response.suggestions[0].word, "阿")
                expectation.fulfill()
            case .failure:
                XCTFail("GoogleInputService.send failed")
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 10.0)
    }
}
