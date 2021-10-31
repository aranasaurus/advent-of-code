//
//  Day1Tests.swift
//  advent-of-code-2020Tests
//
//  Created by Ryan Arana on 10/29/21.
//

import XCTest

@testable import advent_of_code_2020

class Day1Tests: XCTestCase {
    func testEmptyList() async {
        let entry = Day1Part1Entry()
        let result = await entry.run(for: [])
        XCTAssertEqual(result, 0)
    }

    func test2ItemList_doesNotAddUpTo2020() async {
        let entry = Day1Part1Entry()
        let result = await entry.run(for: [2, 3])
        XCTAssertEqual(result, 0)
    }

    func test2ItemList_doesAddUpTo2020() async {
        let entry = Day1Part1Entry()
        let result = await entry.run(for: [2000, 20])
        XCTAssertEqual(result, 40000)
    }
    
    func testItemList_manyEntries2DoAddUpTo2020() async {
        let entry = Day1Part1Entry()
        let result = await entry.run(for: [2, 3, 30, 140, 1900, 23, 42, 666, 1334, 1354])
        XCTAssertEqual(result, 666 * 1354)
    }

    func testItemList_manyEntries2PairsAddUpTo2020_firstPairReturned() async {
        let entry = Day1Part1Entry()
        let result = await entry.run(for: [2, 3, 30, 140, 2000, 20, 1900, 23, 42, 666, 1334, 1354])
        XCTAssertEqual(result, 40000)
    }

    func testFirstAndLastAddUpTo2020() async {
        let entry = Day1Part1Entry()
        let result = await entry.run(for: [2000, 30, 140, 2000, 20, 1900, 23, 42, 666, 20])
        XCTAssertEqual(result, 40000)
    }

    func testFirstAndLastAddUpTo2020_reversed() async {
        let entry = Day1Part1Entry()
        let result = await entry.run(for: [20, 30, 140, 2000, 20, 1900, 23, 42, 666, 2000])
        XCTAssertEqual(result, 40000)
    }
}
