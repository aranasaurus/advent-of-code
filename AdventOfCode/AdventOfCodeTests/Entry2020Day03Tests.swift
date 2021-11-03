//
//  Entry2020Day03Tests.swift
//  AdventOfCodeTests
//
//  Created by Ryan Arana on 11/2/21.
//

import XCTest

@testable import AdventOfCode

class Entry2020Day03Tests: XCTestCase {

    func testSampleData() async throws {
        let sampleData = [
            "..##.......",
            "#...#...#..",
            ".#....#..#.",
            "..#.#...#.#",
            ".#...##..#.",
            "..#.##.....",
            ".#.#.#....#",
            ".#........#",
            "#.##...#...",
            "#...##....#",
            ".#..#...#.#"
        ]
        let entry1 = Entry2020Day03(.part1)
        let result1 = await entry1.run(for: sampleData)
        XCTAssertEqual(result1, 7)
    }

    func testInput() async throws {
        try await validateInput(Entry2020Day03(.part1), expected: "230")
    }

}
