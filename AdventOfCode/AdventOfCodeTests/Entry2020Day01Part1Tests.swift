//
//  Entry2020Day01Part1Tests.swift
//  AdventOfCodeTests
//
//  Created by Ryan Arana on 10/29/21.
//

import XCTest

@testable import AdventOfCode

class Entry2020Day01Part1Tests: XCTestCase {
    func testEmptyList() async {
        let entry = Entry2020Day01Part1()
        let result = await entry.run(for: [])
        XCTAssertEqual(result, 0)
    }

    func test2ItemList_doesNotAddUpTo2020() async {
        let entry = Entry2020Day01Part1()
        let result = await entry.run(for: [2, 3])
        XCTAssertEqual(result, 0)
    }

    func test2ItemList_doesAddUpTo2020() async {
        let entry = Entry2020Day01Part1()
        let result = await entry.run(for: [2000, 20])
        XCTAssertEqual(result, 40000)
    }
    
    func testItemList_manyEntries2DoAddUpTo2020() async {
        let entry = Entry2020Day01Part1()
        let result = await entry.run(for: [2, 3, 30, 140, 1900, 23, 42, 666, 1334, 1354])
        XCTAssertEqual(result, 666 * 1354)
    }

    func testItemList_manyEntries2PairsAddUpTo2020_firstPairReturned() async {
        let entry = Entry2020Day01Part1()
        let result = await entry.run(for: [2, 3, 30, 140, 2000, 20, 1900, 23, 42, 666, 1334, 1354])
        XCTAssertEqual(result, 40000)
    }

    func testFirstAndLastAddUpTo2020() async {
        let entry = Entry2020Day01Part1()
        let result = await entry.run(for: [2000, 30, 140, 2000, 20, 1900, 23, 42, 666, 20])
        XCTAssertEqual(result, 40000)
    }

    func testFirstAndLastAddUpTo2020_reversed() async {
        let entry = Entry2020Day01Part1()
        let result = await entry.run(for: [20, 30, 140, 2000, 20, 1900, 23, 42, 666, 2000])
        XCTAssertEqual(result, 40000)
    }

    func testSampleData() async {
        let entry = Entry2020Day01Part1()
        let result = await entry.run(for: [
            1721,
            979,
            366,
            299,
            675,
            1456
        ])
        XCTAssertEqual(result, 514579)
    }

    func testInput() async throws {
        let entry = Entry2020Day01Part1()
        try await entry.run()

        let answerExpectation = expectation(description: "Answer should be published.")
        let cancellable = entry.$answer
            .dropFirst()
            .sink { answer in
                XCTAssertEqual(answer, "1,014,171")
                answerExpectation.fulfill()
            }

        await waitForExpectations(timeout: 1)
        cancellable.cancel()
    }
}
