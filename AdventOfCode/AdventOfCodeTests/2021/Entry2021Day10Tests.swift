//
//  Entry2021Day10Tests.swift
//  AdventOfCodeTests
//
//  Created by Ryan Arana on 12/9/21.
//

import XCTest

@testable import AdventOfCode

class Entry2021Day10Tests: XCTestCase {
    func testSampleData() async {
        let sample = [
            "[({(<(())[]>[[{[]{<()<>>",
            "[(()[<>])]({[<{<<[]>>(",
            "{([(<{}[<>[]}>{[]{[(<()>",
            "(((({<>}<{<{<>}{[]{[]{}",
            "[[<[([]))<([[{}[[()]]]",
            "[{[{({}]{}}([{[{{{}}([]",
            "{<[[]]>}<{[{[{[]{()[[[]",
            "[<(<(<(<{}))><([]([]()",
            "<{([([[(<>()){}]>(<<{{",
            "<{([{{}}[<[[[<>{}]]]>[]]"
        ]
        let entry = Entry2021Day10(.part1)
        let result = await entry.run(for: sample)
        XCTAssertEqual(result, 26397)

        entry.part = .part2
        let part2Result = await entry.run(for: sample)
        XCTAssertEqual(part2Result, 288957)
    }

    func testInput() async throws {
        try await validateInput(Entry2021Day10(.part1), expected: "411471")
        try await validateInput(Entry2021Day10(.part2), expected: "3122628974")
    }
}
