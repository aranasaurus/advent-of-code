//
//  Entry2020Day02Part1Tests.swift
//  AdventOfCodeTests
//
//  Created by Ryan Arana on 11/1/21.
//

import XCTest

@testable import AdventOfCode

class Entry2020Day02Part1Tests: XCTestCase {

    func testSampleData() async throws {
        let entry = Entry2020Day02Part1()
        let result = await entry.run(for: [
            "1-3 a: abcde",
            "1-3 b: cdefg",
            "2-9 c: ccccccccc"
        ].compactMap(Entry2020Day02Part1.Components.init(line:)))
        XCTAssertEqual(result, 2)
    }

    func testInput() async throws {
        try await validateInput(Entry2020Day02Part1(), expected: "622")
    }

    func testComponents() {
        guard var components = Entry2020Day02Part1.Components(line: "1-3 a: abcde") else {
            XCTFail("Failed to parse valid line")
            return
        }

        XCTAssertEqual(components.letter, "a")
        XCTAssertEqual(components.password, "abcde")
        XCTAssertEqual(components.occurrenceRange, 1...3)
        XCTAssert(components.valid)

        components.letter = "z"
        XCTAssertFalse(components.valid)

        components.password += "zzz"
        XCTAssert(components.valid)

        components.password += "z"
        XCTAssertFalse(components.valid)
    }
}
