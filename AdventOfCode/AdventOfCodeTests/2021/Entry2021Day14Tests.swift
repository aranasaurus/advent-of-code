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
    }
//
//    func testInput() async throws {
//        try await validateInput(Entry2021Day14(.part1), expected: "712")
//        // This one you have to look at the console and see what it prints out to really test it. It should print BLHFJPJF in hashtags.
//        try await validateInput(Entry2021Day14(.part2), expected: "90")
//    }
}
