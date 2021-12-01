//
//  Entry2020Day01Tests.swift
//  AdventOfCodeTests
//
//  Created by Ryan Arana on 10/29/21.
//

import XCTest

@testable import AdventOfCode

class Entry2020Day01Tests: XCTestCase {
    func testSampleData() async {
        let sample = [
            1721,
            979,
            366,
            299,
            675,
            1456
        ]
        let entry = Entry2020Day01(.part1)
        let result = await entry.run(for: sample)
        XCTAssertEqual(result, 514579)

        entry.part = .part2
        let part2Result = await entry.run(for: sample)
        XCTAssertEqual(part2Result, 241861950)
    }

    func testInput() async throws {
        try await validateInput(Entry2020Day01(.part1), expected: "1,014,171")
        try await validateInput(Entry2020Day01(.part2), expected: "46,584,630")
    }
}
