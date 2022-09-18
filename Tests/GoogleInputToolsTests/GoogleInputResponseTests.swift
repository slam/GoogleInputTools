import Foundation
@testable import GoogleInputTools
import XCTest

let jsonResponseWithoutMatchedLength = """
[
  "SUCCESS",
  [
     [
        "ma",
        [
           "嗎",
           "馬",
           "買",
           "媽",
           "碼",
           "埋",
           "麻",
           "賣",
           "孖",
           "物",
           "嘛",
           "咪",
           "乜"
        ],
        [

        ],
        {
           "annotation":[
              "ma",
              "ma",
              "maai",
              "ma",
              "ma",
              "maai",
              "ma",
              "maai",
              "ma",
              "mat",
              "ma",
              "maai",
              "mat"
           ],
           "candidate_type":[
              0,
              0,
              0,
              0,
              0,
              0,
              0,
              0,
              0,
              0,
              0,
              0,
              0
           ],
           "lc":[
              "69",
              "69",
              "69",
              "69",
              "69",
              "69",
              "69",
              "69",
              "69",
              "69",
              "69",
              "69",
              "69"
           ]
        }
     ]
  ]
]
""".data(using: .utf8)

let jsonResponseWithMatchedLength = """
[
   "SUCCESS",
   [
      [
         "tamadik",
         [
            "他媽的",
            "他媽",
            "大馬",
            "他",
            "他嗎",
            "打麻",
            "她",
            "大罵",
            "大",
            "打",
            "太",
            "它",
            "得"
         ],
         [

         ],
         {
            "annotation":[
               "ta ma dik",
               "ta ma",
               "daai ma",
               "ta",
               "ta ma",
               "da ma",
               "ta",
               "daai ma",
               "daai",
               "da",
               "taai",
               "ta",
               "dak"
            ],
            "candidate_type":[
               0,
               0,
               0,
               0,
               0,
               0,
               0,
               0,
               0,
               0,
               0,
               0,
               0
            ],
            "lc":[
               "69 69 69",
               "69 69",
               "69 69",
               "69",
               "69 69",
               "69 69",
               "69",
               "69 69",
               "69",
               "69",
               "69",
               "69",
               "69"
            ],
            "matched_length":[
               7,
               4,
               4,
               2,
               4,
               4,
               2,
               4,
               2,
               2,
               2,
               2,
               2
            ]
         }
      ]
   ]
]
""".data(using: .utf8)

let jsonResponseWithError = """
[
   "FAILED_TO_PARSE_REQUEST_BODY"
]
""".data(using: .utf8)

let jsonResponseForC = """
["SUCCESS",[["c",[],[],{"candidate_type":[]}]]]
""".data(using: .utf8)

let jsonResponseEmpty = """
["SUCCESS",[]]
""".data(using: .utf8)

final class GoogleInputResponseTests: XCTestCase {
    func testDecodeJsonWithoutMatchedLength() throws {
        let decoder = JSONDecoder()
        let response = try decoder.decode(GoogleInputResponse.self,
                                          from: jsonResponseWithoutMatchedLength!)
        XCTAssertNotNil(response)
        XCTAssertEqual(response.status, GoogleInputResponse.Status.success)
        XCTAssertEqual(response.input, "ma")
        XCTAssertEqual(response.suggestions.count, 13)
        XCTAssertEqual(response.suggestions[0].word, "嗎")
        XCTAssertEqual(response.suggestions[0].matchedLength, 2)
        XCTAssertEqual(response.suggestions[0].annotation, "ma")
        XCTAssertEqual(response.suggestions[0].languageCode, "69")
        XCTAssertEqual(response.suggestions[12].word, "乜")
        XCTAssertEqual(response.suggestions[12].matchedLength, 2)
        XCTAssertEqual(response.suggestions[12].annotation, "mat")
        XCTAssertEqual(response.suggestions[12].languageCode, "69")
    }

    func testDecodeJsonWithMatchedLength() throws {
        let decoder = JSONDecoder()
        let response = try decoder.decode(GoogleInputResponse.self,
                                          from: jsonResponseWithMatchedLength!)
        XCTAssertNotNil(response)
        XCTAssertEqual(response.status, GoogleInputResponse.Status.success)
        XCTAssertEqual(response.input, "tamadik")
        XCTAssertEqual(response.suggestions.count, 13)
        XCTAssertEqual(response.suggestions[0].word, "他媽的")
        XCTAssertEqual(response.suggestions[0].matchedLength, 7)
        XCTAssertEqual(response.suggestions[0].annotation, "ta ma dik")
        XCTAssertEqual(response.suggestions[0].languageCode, "69 69 69")
        XCTAssertEqual(response.suggestions[12].word, "得")
        XCTAssertEqual(response.suggestions[12].annotation, "dak")
        XCTAssertEqual(response.suggestions[12].languageCode, "69")
    }

    func testDecodeResponseForTheLetterC() throws {
        let decoder = JSONDecoder()
        let response = try decoder.decode(GoogleInputResponse.self,
                                          from: jsonResponseForC!)
        XCTAssertNotNil(response)
        XCTAssertEqual(response.status, GoogleInputResponse.Status.success)
        XCTAssertEqual(response.input, "c")
    }

    func testDecodeEmptySuccess() throws {
        let decoder = JSONDecoder()
        let response = try decoder.decode(GoogleInputResponse.self,
                                          from: jsonResponseEmpty!)
        XCTAssertNotNil(response)
        XCTAssertEqual(response.status, GoogleInputResponse.Status.success)
        XCTAssertEqual(response.input, "")
    }

    func testHandleParseError() throws {
        let decoder = JSONDecoder()
        let response = try decoder.decode(GoogleInputResponse.self,
                                          from: jsonResponseWithError!)
        XCTAssertNotNil(response)
        XCTAssertEqual(response.status, GoogleInputResponse.Status.failedToParseRequestBody)
    }
}
