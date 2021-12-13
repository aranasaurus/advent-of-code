//
//  Entry2021Day13Tests.swift
//  AdventOfCodeTests
//
//  Created by Ryan Arana on 12/12/21.
//

import XCTest

@testable import AdventOfCode

class Entry2021Day13Tests: XCTestCase {
    func testSampleData() async {
        let sample1 = [
            "6,10",
            "0,14",
            "9,10",
            "0,3",
            "10,4",
            "4,11",
            "6,0",
            "6,12",
            "4,1",
            "0,13",
            "10,12",
            "3,4",
            "3,0",
            "8,4",
            "1,10",
            "2,14",
            "8,10",
            "9,0",
            "",
            "fold along y=7",
            "fold along x=5"
        ]
        let entry = Entry2021Day13(.part1)
        let result = await entry.run(for: sample1)
        XCTAssertEqual(result, 17)
    }

    func testInput() async throws {
        try await validateInput(Entry2021Day13(.part1), expected: "712")
        // This one you have to look at the console and see what it prints out to really test it. It should print BLHFJPJF in hashtags.
        try await validateInput(Entry2021Day13(.part2), expected: "90")
    }
}
