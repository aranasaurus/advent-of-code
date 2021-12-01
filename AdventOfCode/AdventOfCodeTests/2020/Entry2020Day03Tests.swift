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

        let entry2 = Entry2020Day03(.part2)
        let result2 = await entry2.run(for: sampleData)
        XCTAssertEqual(result2, 336)
    }

    func testInput() async throws {
        try await validateInput(Entry2020Day03(.part1), expected: "230")
        try await validateInput(Entry2020Day03(.part2), expected: "9,533,698,720")
    }

}
