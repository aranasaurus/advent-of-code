//
//  Entry2021Day01Tests.swift
//  AdventOfCodeTests
//
//  Created by Ryan Arana on 12/1/21.
//

import XCTest

@testable import AdventOfCode

class Entry2021Day01Tests: XCTestCase {
    func testSampleData() async {
        let sample = [
            199,
            200,
            208,
            210,
            200,
            207,
            240,
            269,
            260,
            263
        ]

        let entry = Entry2021Day01(.part1)
        let result = await entry.run(for: sample)
        XCTAssertEqual(result, 7)

//        entry.part = .part2
//        let part2Result = await entry.run(for: sample)
//        XCTAssertEqual(part2Result, 241861950)
    }

    func testInput() async throws {
        try await validateInput(Entry2021Day01(.part1), expected: "1722")
//        try await validateInput(Entry2020Day01(.part2), expected: "46,584,630")
    }

}
