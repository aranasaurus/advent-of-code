//
//  Entry2021Day05Tests.swift
//  AdventOfCodeTests
//
//  Created by Ryan Arana on 12/5/21.
//

import XCTest

@testable import AdventOfCode

class Entry2021Day05Tests: XCTestCase {
    func testSampleData() async {
        let sample = [
            "0,9 -> 5,9",
            "8,0 -> 0,8",
            "9,4 -> 3,4",
            "2,2 -> 2,1",
            "7,0 -> 7,4",
            "6,4 -> 2,0",
            "0,9 -> 2,9",
            "3,4 -> 1,4",
            "0,0 -> 8,8",
            "5,5 -> 8,2"
        ]

        let entry = Entry2021Day05(.part1)
        let result = await entry.run(for: sample)
        XCTAssertEqual(result, 5)

        entry.part = .part2
        let part2Result = await entry.run(for: sample)
        XCTAssertEqual(part2Result, 12)
    }

    func testInput() async throws {
        try await validateInput(Entry2021Day05(.part1), expected: "5576")
        try await validateInput(Entry2021Day05(.part2), expected: "18144")
    }
}
