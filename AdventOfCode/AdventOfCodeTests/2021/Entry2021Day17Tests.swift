//
//  Entry2021Day16Tests.swift
//  AdventOfCodeTests
//
//  Created by Ryan Arana on 12/23/21.
//

import XCTest

@testable import AdventOfCode

private typealias Entry = Entry2021Day17

class Entry2021Day17Tests: XCTestCase {
    func testSampleData() async {
        let entry = Entry(.part1)
        let part1Result = await entry.run(for: "target area: x=20..30, y=-10..-5")
        XCTAssertEqual(part1Result, 45)
    }

    func testInput() async throws {
        let part1 = Entry(.part1)
        try await validateInput(part1, expected: "6903")
//
//        let part2 = Entry(.part2)
//        try await validateInput(part2, expected: "333794664059")
    }
}
