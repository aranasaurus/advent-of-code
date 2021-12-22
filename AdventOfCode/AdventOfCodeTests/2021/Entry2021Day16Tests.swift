//
//  Entry2021Day16Tests.swift
//  AdventOfCodeTests
//
//  Created by Ryan Arana on 12/21/21.
//

import XCTest

@testable import AdventOfCode

private typealias Entry = Entry2021Day16

class Entry2021Day16Tests: XCTestCase {
    func testSampleData() async {
        let entry = Entry(.part1)

        XCTAssertEqual(entry.run(for: "8A004A801A8002F478"), 16)
        XCTAssertEqual(entry.run(for: "620080001611562C8802118E34"), 12)
        XCTAssertEqual(entry.run(for: "C0015000016115A2E0802F182340"), 23)
        XCTAssertEqual(entry.run(for: "A0016C880162017C3686B18A3D4780"), 31)
    }

//    func testInput() async throws {
//        let part1 = Entry2021Day16(.part1)
//        try await validateInput(part1, expected: "553")
//
//        let part2 = Entry2021Day16(.part2)
//        try await validateInput(part2, expected: "2858")
//    }
}
