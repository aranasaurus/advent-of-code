//
//  Entry2021Day12Tests.swift
//  AdventOfCodeTests
//
//  Created by Ryan Arana on 12/11/21.
//

import XCTest

@testable import AdventOfCode

class Entry2021Day12Tests: XCTestCase {
    func testSampleData() async {
        let sample1 = [
            "start-A",
            "start-b",
            "A-c",
            "A-b",
            "b-d",
            "A-end",
            "b-end"
        ]
        let entry = Entry2021Day12(.part1)
        var result = await entry.run(for: sample1)
        XCTAssertEqual(result, 10)

        let sample2 = [
            "dc-end",
            "HN-start",
            "start-kj",
            "dc-start",
            "dc-HN",
            "LN-dc",
            "HN-end",
            "kj-sa",
            "kj-HN",
            "kj-dc"
        ]
        result = await entry.run(for: sample2)
        XCTAssertEqual(result, 19)

        let sample3 = [
            "fs-end",
            "he-DX",
            "fs-he",
            "start-DX",
            "pj-DX",
            "end-zg",
            "zg-sl",
            "zg-pj",
            "pj-he",
            "RW-he",
            "fs-DX",
            "pj-RW",
            "zg-RW",
            "start-pj",
            "he-WI",
            "zg-he",
            "pj-fs",
            "start-RW"
        ]
        result = await entry.run(for: sample3)
        XCTAssertEqual(result, 226)
    }

//    func testInput() async throws {
//        try await validateInput(Entry2021Day12(.part1), expected: "1691")
//        try await validateInput(Entry2021Day12(.part2), expected: "216")
//    }
}
