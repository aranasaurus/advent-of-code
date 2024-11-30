//
//  Entry2020Day06Tests.swift
//  AdventOfCodeTests
//
//  Created by Ryan Arana on 11/6/21.
//

import XCTest

@testable import AdventOfCode

class Entry2020Day06Tests: XCTestCase {

    func testSampleData() async throws {
        let sampleData = [
            "abc",
            "",
            "a",
            "b",
            "c",
            "",
            "ab",
            "ac",
            "",
            "a",
            "a",
            "a",
            "a",
            "",
            "b"
        ]

        let entry1 = Entry2020Day06(.part1)
        let result1 = await entry1.run(for: sampleData.chunked)
        XCTAssertEqual(result1, 11)

        let entry2 = Entry2020Day06(.part2)
        let result2 = await entry2.run(for: sampleData.chunked)
        XCTAssertEqual(result2, 6)
    }

    func testInput() async throws {
        try await validateInput(Entry2020Day06(.part1), expected: "6596")
        try await validateInput(Entry2020Day06(.part2), expected: "3219")
    }

    func testParseChunk() {
        let chunk = ["a", "abc", "abc", "ac"]
        let entry = Entry2020Day06(.part1)
        var result = entry.parse(chunk: chunk)
        XCTAssertEqual(result, 3)

        entry.part = .part2
        result = entry.parse(chunk: chunk)
        XCTAssertEqual(result, 1)
    }
}
