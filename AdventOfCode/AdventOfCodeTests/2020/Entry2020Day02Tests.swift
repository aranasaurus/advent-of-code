//
//  Entry2020Day02Tests.swift
//  AdventOfCodeTests
//
//  Created by Ryan Arana on 11/1/21.
//

import XCTest

@testable import AdventOfCode

class Entry2020Day02Tests: XCTestCase {

    func testSampleData() async throws {
        let sampleData = [
            "1-3 a: abcde",
            "1-3 b: cdefg",
            "2-9 c: ccccccccc"
        ]
        let entry1 = Entry2020Day02(.part1)
        let result1 = await entry1.run(for: sampleData.compactMap({ Entry2020Day02.Components(line: $0, part: .part1) }))
        XCTAssertEqual(result1, 2)

        let entry2 = Entry2020Day02(.part2)
        let result2 = await entry2.run(for: sampleData.compactMap({ Entry2020Day02.Components(line: $0, part: .part2) }))
        XCTAssertEqual(result2, 1)
    }

    func testInput() async throws {
        try await validateInput(Entry2020Day02(.part1), expected: "622")
        try await validateInput(Entry2020Day02(.part2), expected: "263")
    }

    func testComponents() {
        guard var components = Entry2020Day02.Components(line: "1-3 a: abcde", part: .part2) else {
            XCTFail("Failed to parse valid line")
            return
        }

        XCTAssertEqual(components.letter, "a")
        XCTAssertEqual(components.password, "abcde")
        XCTAssertEqual(components.occurrenceRange, 1...3)
        XCTAssert(components.valid)

        components.password = "abacde"
        XCTAssertFalse(components.valid)

        components.password = "bbacde"
        XCTAssert(components.valid)

        components.password = "aaaaaa"
        XCTAssertFalse(components.valid)

        components.password = "baaaaaa"
        XCTAssert(components.valid)

        components.letter = "z"
        XCTAssertFalse(components.valid)
    }

    func testPart2Valid() {
        guard var components = Entry2020Day02.Components(line: "1-3 a: abcde", part: .part2) else {
            XCTFail("Failed to parse valid line")
            return
        }

        XCTAssert(components.valid)

        components.password = "abade"
        XCTAssertFalse(components.valid)
    }
}
