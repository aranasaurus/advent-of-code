//
//  Day1Part2Tests.swift
//  advent-of-code-2020Tests
//
//  Created by Ryan Arana on 10/31/21.
//

import XCTest

@testable import advent_of_code_2020

class Day1Part2Tests: XCTestCase {
    func testSampleData() async {
        let entry = Day1Part2Entry()
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
}
