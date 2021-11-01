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
}
