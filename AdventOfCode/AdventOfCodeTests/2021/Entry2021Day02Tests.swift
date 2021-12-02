//
//  Entry2021Day02Tests.swift
//  AdventOfCodeTests
//
//  Created by Ryan Arana on 12/1/21.
//

import XCTest

@testable import AdventOfCode

class Entry2021Day02Tests: XCTestCase {
    func testSampleData() async {
        let sample = [
            "forward 5",
            "down 5",
            "forward 8",
            "up 3",
            "down 8",
            "forward 2"
        ]

        let entry = Entry2021Day02(.part1)
        let result = await entry.run(for: sample)
        XCTAssertEqual(result, 150)

//        entry.part = .part2
//        let part2Result = await entry.run(for: sample)
//        XCTAssertEqual(part2Result, 5)
    }

    func testInput() async throws {
        try await validateInput(Entry2021Day02(.part1), expected: "2120749")
//        try await validateInput(Entry2021Day02(.part2), expected: "1748")
    }
}
