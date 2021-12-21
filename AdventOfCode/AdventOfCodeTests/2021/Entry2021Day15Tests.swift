//
//  Entry2021Day15Tests.swift
//  AdventOfCodeTests
//
//  Created by Ryan Arana on 12/16/21.
//

import XCTest

@testable import AdventOfCode

class Entry2021Day15Tests: XCTestCase {
    func testSampleData() async {
        let sample1 = [
            "1163751742",
            "1381373672",
            "2136511328",
            "3694931569",
            "7463417111",
            "1319128137",
            "1359912421",
            "3125421639",
            "1293138521",
            "2311944581"
        ]
        let entry = Entry2021Day15(.part1)
        let result = await entry.run(for: sample1)
        XCTAssertEqual(result, 40)
    }

    func testInput() async throws {
        try await validateInput(Entry2021Day15(.part1), expected: "553")
//        try await validateInput(Entry2021Day15(.part2), expected: "5208377027195")
    }
}
