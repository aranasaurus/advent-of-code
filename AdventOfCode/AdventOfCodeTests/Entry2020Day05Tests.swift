//
//  Entry2020Day05Tests.swift
//  AdventOfCodeTests
//
//  Created by Ryan Arana on 11/5/21.
//

import XCTest

@testable import AdventOfCode

class Entry2020Day05Tests: XCTestCase {
    func testSampleData() async throws {
        let sampleData = [
            "FBFBBFFRLR": 357,
            "BFFFBBFRRR": 567,
            "FFFBBBFRRR": 119,
            "BBFFBBFRLL": 820
        ]
        let entry1 = Entry2020Day05(.part1)
        for (key, value) in sampleData {
            let result = entry1.parse(line: key)
            XCTAssertEqual(result, value)
        }
        let result1 = await entry1.run(for: sampleData.keys.sorted())
        XCTAssertEqual(result1, 820)

//        let entry2 = Entry2020Day03(.part2)
//        let result2 = await entry2.run(for: sampleData.keys.sorted())
//        XCTAssertEqual(result2, 336)
    }

    func testInput() async throws {
        try await validateInput(Entry2020Day05(.part1), expected: "947")
//        try await validateInput(Entry2020Day05(.part2), expected: "9,533,698,720")
    }
}
