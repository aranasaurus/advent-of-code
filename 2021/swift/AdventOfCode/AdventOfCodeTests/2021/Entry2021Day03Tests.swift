//
//  Entry2021Day03Tests.swift
//  AdventOfCodeTests
//
//  Created by Ryan Arana on 12/3/21.
//

import XCTest

@testable import AdventOfCode

class Entry2021Day03Tests: XCTestCase {
    func testSampleData() async {
        let sample = [
            "00100",
            "11110",
            "10110",
            "10111",
            "10101",
            "01111",
            "00111",
            "11100",
            "10000",
            "11001",
            "00010",
            "01010"
        ]

        let entry = Entry2021Day03(.part1)
        let result = await entry.run(for: sample)
        XCTAssertEqual(result, 198)

        entry.part = .part2
        let part2Result = await entry.run(for: sample)
        XCTAssertEqual(part2Result, 230)
    }

    func testInput() async throws {
        try await validateInput(Entry2021Day03(.part1), expected: "3320834")
        try await validateInput(Entry2021Day03(.part2), expected: "4481199")
    }
}
