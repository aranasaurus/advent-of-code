//
//  Entry2021Day11Tests.swift
//  AdventOfCodeTests
//
//  Created by Ryan Arana on 12/11/21.
//

import XCTest

@testable import AdventOfCode

class Entry2021Day11Tests: XCTestCase {
    func testSampleData() async {
        let sample = [
            "5483143223",
            "2745854711",
            "5264556173",
            "6141336146",
            "6357385478",
            "4167524645",
            "2176841721",
            "6882881134",
            "4846848554",
            "5283751526"
        ]
        let entry = Entry2021Day11(.part1)
        let result = await entry.run(for: sample)
        XCTAssertEqual(result, 1656)

//        entry.part = .part2
//        let part2Result = await entry.run(for: sample)
//        XCTAssertEqual(part2Result, 288957)
    }

//    func testInput() async throws {
//        try await validateInput(Entry2021Day11(.part1), expected: "411471")
//        try await validateInput(Entry2021Day11(.part2), expected: "3122628974")
//    }
}
