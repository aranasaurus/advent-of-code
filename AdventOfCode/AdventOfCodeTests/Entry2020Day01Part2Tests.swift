//
//  Entry2020Day01Part1Tests.swift
//  AdventOfCodeTests
//
//  Created by Ryan Arana on 10/31/21.
//

import XCTest

@testable import AdventOfCode

class Entry2020Day01Part2Tests: XCTestCase {
    func testSampleData() async {
        let entry = Entry2020Day01Part2()
        let result = await entry.run(for: [
            1721,
            979,
            366,
            299,
            675,
            1456
        ])

        XCTAssertEqual(result, 241861950)
    }

    func testInput() async throws {
        let entry = Entry2020Day01Part2()
        try await entry.run()

        let answerExpectation = expectation(description: "Answer should be published.")
        let cancellable = entry.$answer
            .dropFirst()
            .sink { answer in
                XCTAssertEqual(answer, "46,584,630")
                answerExpectation.fulfill()
            }

        await waitForExpectations(timeout: 1)
        cancellable.cancel()
    }
}
