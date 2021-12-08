//
//  Entry2021Day08Tests.swift
//  AdventOfCodeTests
//
//  Created by Ryan Arana on 12/8/21.
//

import XCTest

@testable import AdventOfCode

class Entry2021Day08Tests: XCTestCase {
    func testSampleData() async {
        let sample = [
            "be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb | fdgacbe cefdb cefbgd gcbe",
            "edbfga begcd cbg gc gcadebf fbgde acbgfd abcde gfcbed gfec | fcgedb cgb dgebacf gc",
            "fgaebd cg bdaec gdafb agbcfd gdcbef bgcad gfac gcb cdgabef | cg cg fdcagb cbg",
            "fbegcd cbd adcefb dageb afcb bc aefdc ecdab fgdeca fcdbega | efabcd cedba gadfec cb",
            "aecbfdg fbg gf bafeg dbefa fcge gcbea fcaegb dgceab fcbdga | gecf egdcabf bgf bfgea",
            "fgeab ca afcebg bdacfeg cfaedg gcfdb baec bfadeg bafgc acf | gebdcfa ecba ca fadegcb",
            "dbcfg fgd bdegcaf fgec aegbdf ecdfab fbedc dacgb gdcebf gf | cefg dcbef fcge gbcadfe",
            "bdfegc cbegaf gecbf dfcage bdacg ed bedf ced adcbefg gebcd | ed bcgafe cdgba cbgef",
            "egadfb cdbfeg cegd fecab cgb gbdefca cg fgcdab egfdb bfceg | gbdfcae bgc cg cgb",
            "gcafb gcf dcaebfg ecagb gf abcdeg gaef cafbge fdbac fegbdc | fgae cfgab fg bagce"
        ]
        let entry = Entry2021Day08(.part1)
        let result = await entry.run(for: sample)
        XCTAssertEqual(result, 26)

//        entry.part = .part2
//        let part2Result = await entry.run(for: sample)
//        XCTAssertEqual(part2Result, 168)
    }

    func testInput() async throws {
        try await validateInput(Entry2021Day08(.part1), expected: "247")
//        try await validateInput(Entry2021Day08(.part2), expected: "88612508")
    }
}
