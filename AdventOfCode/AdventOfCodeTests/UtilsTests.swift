//
//  UtilsTests.swift
//  AdventOfCodeTests
//
//  Created by Ryan Arana on 11/6/21.
//

import XCTest

@testable import AdventOfCode

class UtilsTests: XCTestCase {

    func testChunks() {
        XCTAssertEqual([
            "stuff1",
            "stuff2",
            "",
            "other1",
            "other2"
        ].chunked, [
            ["stuff1", "stuff2"],
            ["other1", "other2"]
        ])
    }

    func testChunksPerformance() throws {
        let day6Entry = Entry2020Day06(.part1)
        var lines = try String(contentsOf: try day6Entry.fileURL()).split(separator: "\n", omittingEmptySubsequences: false).map(String.init(_:))

        for _ in 1...5 {
            lines.append(contentsOf: lines)
        }

        self.measure {
            XCTAssertEqual(lines.chunked.count, 15552)
        }
    }
}
