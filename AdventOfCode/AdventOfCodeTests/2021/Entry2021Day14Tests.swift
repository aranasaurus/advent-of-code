//
//  Entry2021Day14Tests.swift
//  AdventOfCodeTests
//
//  Created by Ryan Arana on 12/13/21.
//

import XCTest

@testable import AdventOfCode

class Entry2021Day14Tests: XCTestCase {
    func testSampleData() async {
        let sample1 = [
            "NNCB",
            "",
            "CH -> B",
            "HH -> N",
            "CB -> H",
            "NH -> C",
            "HB -> C",
            "HC -> B",
            "HN -> C",
            "NN -> C",
            "BH -> H",
            "NC -> B",
            "NB -> B",
            "BN -> B",
            "BB -> N",
            "BC -> B",
            "CC -> N",
            "CN -> C"
        ]
        let entry = Entry2021Day14(.part1)
        let result = await entry.run(for: sample1)
        XCTAssertEqual(result, 1588)
        
        entry.part = .part2
        let result2 = await entry.run(for: sample1)
        XCTAssertEqual(result2, 2188189693529)
    }

    func testInput() async throws {
        try await validateInput(Entry2021Day14(.part1), expected: "2874")
        try await validateInput(Entry2021Day14(.part2), expected: "5208377027195")
    }
}
