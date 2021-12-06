//
//  Entry2021Day06Tests.swift
//  AdventOfCodeTests
//
//  Created by Ryan Arana on 12/6/21.
//

import XCTest

@testable import AdventOfCode

class Entry2021Day06Tests: XCTestCase {
    func testSampleData() async {
        let sample = "3,4,3,1,2"

        let entry = Entry2021Day06(.part1)
        let result = await entry.run(for: sample)
        XCTAssertEqual(result, 5934)

        entry.part = .part2
        let part2Result = await entry.run(for: sample)
        XCTAssertEqual(part2Result, 26_984_457_539)
    }

    func testInput() async throws {
        try await validateInput(Entry2021Day06(.part1), expected: "349549")
        try await validateInput(Entry2021Day06(.part2), expected: "1589590444365")
    }
}
