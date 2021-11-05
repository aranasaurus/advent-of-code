//
//  Entry2020Day04Tests.swift
//  AdventOfCodeTests
//
//  Created by Ryan Arana on 11/3/21.
//

import XCTest

@testable import AdventOfCode

class Entry2020Day04Tests: XCTestCase {

    func testSampleData() async throws {
        let sampleData = [
            "ecl:gry pid:860033327 eyr:2020 hcl:#fffffd",
            "byr:1937 iyr:2017 cid:147 hgt:183cm",
            "",
            "iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884",
            "hcl:#cfa07d byr:1929",
            "",
            "hcl:#ae17e1 iyr:2013",
            "eyr:2024",
            "ecl:brn pid:760753108 byr:1931",
            "hgt:179cm",
            "",
            "hcl:#cfa07d eyr:2025 pid:166559648",
            "iyr:2011 ecl:brn hgt:59in"
        ]
        let entry1 = Entry2020Day04(.part1)
        let result1 = await entry1.run(for: sampleData)
        XCTAssertEqual(result1, 2)

//        let entry2 = Entry2020Day04(.part2)
//        let result2 = await entry2.run(for: sampleData)
//        XCTAssertEqual(result2, 336)
    }

    func testInput() async throws {
        try await validateInput(Entry2020Day04(.part1), expected: "")
//        try await validateInput(Entry2020Day04(.part2), expected: "")
    }

    func testChunk() {
        let entry = Entry2020Day04(.part1)
        XCTAssertEqual(entry.chunk([
            "stuff1",
            "stuff2",
            "",
            "other1",
            "other2"
        ]), [
            ["stuff1", "stuff2"],
            ["other1", "other2"]
        ])
    }

    func testParsePair() {
        var result = Entry2020Day04.Passport.parse(pair: "ecl:gry")
        XCTAssertEqual(result?.key, .eyeColor)
        XCTAssertEqual(result?.value, "gry")

        result = Entry2020Day04.Passport.parse(pair: "pid:860033327")
        XCTAssertEqual(result?.key, .passportID)
        XCTAssertEqual(result?.value, "860033327")

        result = Entry2020Day04.Passport.parse(pair: "hcl:#fffffd")
        XCTAssertEqual(result?.key, .hairColor)
        XCTAssertEqual(result?.value, "#fffffd")
    }

    func testParseLines() {
        let data = [
            "ecl:gry pid:860033327 eyr:2020 hcl:#fffffd",
            "byr:1937 iyr:2017 cid:147 hgt:183cm",
            ""
        ]
        let expected = Entry2020Day04.Passport(
            birthYear: 1937,
            issueYear: 2017,
            expirationYear: 2020,
            height: "183cm",
            hairColor: "#fffffd",
            eyeColor: "gry",
            passportID: 860033327,
            countryID: 147
        )
        let result = Entry2020Day04.Passport.parse(lines: data)
        XCTAssertEqual(result, expected)
    }
}
