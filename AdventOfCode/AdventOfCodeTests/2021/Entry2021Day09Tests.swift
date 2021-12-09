//
//  Entry2021Day09Tests.swift
//  AdventOfCodeTests
//
//  Created by Ryan Arana on 12/9/21.
//

import XCTest

@testable import AdventOfCode

class Entry2021Day09Tests: XCTestCase {
    func testSampleData() async {
        let sample = [
            "2199943210",
            "3987894921",
            "9856789892",
            "8767896789",
            "9899965678"
        ]
        let entry = Entry2021Day09(.part1)
        let result = await entry.run(for: sample)
        XCTAssertEqual(result, 15)

//        entry.part = .part2
//        let part2Result = await entry.run(for: sample)
//        XCTAssertEqual(part2Result, 61229)
    }

    func testInput() async throws {
        try await validateInput(Entry2021Day09(.part1), expected: "526")
//        try await validateInput(Entry2021Day09(.part2), expected: "933305")
    }
}
