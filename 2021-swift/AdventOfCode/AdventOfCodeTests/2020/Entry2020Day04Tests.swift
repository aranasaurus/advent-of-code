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

        let entry2 = Entry2020Day04(.part2)
        let result2 = await entry2.run(for: sampleData)
        XCTAssertEqual(result2, 2)
    }

    func testInput() async throws {
        try await validateInput(Entry2020Day04(.part1), expected: "233")
        try await validateInput(Entry2020Day04(.part2), expected: "111")
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
        // Everything, 2 lines
        var data = [
            "ecl:gry pid:860033327 eyr:2020 hcl:#fffffd",
            "byr:1937 iyr:2017 cid:147 hgt:183cm",
            ""
        ]
        var expected: Entry2020Day04.Passport? = Entry2020Day04.Passport(
            birthYear: 1937,
            issueYear: 2017,
            expirationYear: 2020,
            height: "183cm",
            hairColor: "#fffffd",
            eyeColor: "gry",
            passportID: "860033327",
            countryID: 147
        )
        XCTAssertEqual(Entry2020Day04.Passport.parse(lines: data), expected)

        // Country ID optional, 2 lines
        data = [
            "byr:2013 hgt:70cm pid:76982670 ecl:#4f9a1c",
            "hcl:9e724b eyr:1981 iyr:2027"
        ]
        expected = Entry2020Day04.Passport(
            birthYear: 2013,
            issueYear: 2027,
            expirationYear: 1981,
            height: "70cm",
            hairColor: "9e724b",
            eyeColor: "#4f9a1c",
            passportID: "76982670",
            countryID: nil
        )
        XCTAssertEqual(Entry2020Day04.Passport.parse(lines: data), expected)

        // Everything, 3 lines
        data = [
            "pid:261384974 iyr:2015",
            "hgt:172cm eyr:2020",
            "byr:2001 hcl:#59c2d9 ecl:amb cid:163"
        ]
        expected = Entry2020Day04.Passport(
            birthYear: 2001,
            issueYear: 2015,
            expirationYear: 2020,
            height: "172cm",
            hairColor: "#59c2d9",
            eyeColor: "amb",
            passportID: "261384974",
            countryID: 163
        )
        XCTAssertEqual(Entry2020Day04.Passport.parse(lines: data), expected)

        // Everything, 4 lines
        data = [
            "eyr:2024 hcl:#b6652a",
            "cid:340",
            "byr:1929 ecl:oth iyr:2014 pid:186640193",
            "hgt:193in"
        ]
        expected = Entry2020Day04.Passport(
            birthYear: 1929,
            issueYear: 2014,
            expirationYear: 2024,
            height: "193in",
            hairColor: "#b6652a",
            eyeColor: "oth",
            passportID: "186640193",
            countryID: 340
        )
        XCTAssertEqual(Entry2020Day04.Passport.parse(lines: data), expected)

        // Everything, 1 line
        data = [
            "cid:79 hgt:172cm byr:1932 eyr:2020 pid:127319843 hcl:#6b5442 iyr:2017 ecl:brn"
        ]
        expected = Entry2020Day04.Passport(
            birthYear: 1932,
            issueYear: 2017,
            expirationYear: 2020,
            height: "172cm",
            hairColor: "#6b5442",
            eyeColor: "brn",
            passportID: "127319843",
            countryID: 79
        )
        XCTAssertEqual(Entry2020Day04.Passport.parse(lines: data), expected)

        // Missing CID, 1 line
        data = [
            "byr:1933 hcl:#733820 hgt:165cm eyr:2027 iyr:2018 ecl:oth pid:0952910465"
        ]
        expected = Entry2020Day04.Passport(
            birthYear: 1933,
            issueYear: 2018,
            expirationYear: 2027,
            height: "165cm",
            hairColor: "#733820",
            eyeColor: "oth",
            passportID: "0952910465",
            countryID: nil
        )
        XCTAssertEqual(Entry2020Day04.Passport.parse(lines: data), expected)

        // Missing stuff, 1 line
        data = [
            "hcl:#efcc98 eyr:2039 hgt:158cm byr:2026 pid:216112069"
        ]
        expected = nil
        XCTAssertEqual(Entry2020Day04.Passport.parse(lines: data), expected)

        // String PassportID, 3 lines
        data = [
            "hgt:170cm byr:2012",
            "eyr:1981 hcl:c95b58",
            "pid:#d28b3f cid:302 iyr:1953 ecl:#151ea4"
        ]
        expected = Entry2020Day04.Passport(
            birthYear: 2012,
            issueYear: 1953,
            expirationYear: 1981,
            height: "170cm",
            hairColor: "c95b58",
            eyeColor: "#151ea4",
            passportID: "#d28b3f",
            countryID: 302
        )
        XCTAssertEqual(Entry2020Day04.Passport.parse(lines: data), expected)
    }

    func testIsValid() {
        var passport = Entry2020Day04.Passport(
            birthYear: 1980,
            issueYear: 2012,
            expirationYear: 2025,
            height: "71in",
            hairColor: "#cc1234",
            eyeColor: "blu",
            passportID: "003456789",
            countryID: nil
        )
        XCTAssert(passport.isValid)

        passport.birthYear = 1919
        XCTAssertFalse(passport.isValid)
        passport.birthYear = 2003
        XCTAssertFalse(passport.isValid)
        passport.birthYear = 1920
        XCTAssert(passport.isValid)
        passport.birthYear = 2002
        XCTAssert(passport.isValid)

        passport.issueYear = 2009
        XCTAssertFalse(passport.isValid)
        passport.issueYear = 2021
        XCTAssertFalse(passport.isValid)
        passport.issueYear = 2010
        XCTAssert(passport.isValid)
        passport.issueYear = 2020
        XCTAssert(passport.isValid)

        passport.expirationYear = 2019
        XCTAssertFalse(passport.isValid)
        passport.expirationYear = 2031
        XCTAssertFalse(passport.isValid)
        passport.expirationYear = 2020
        XCTAssert(passport.isValid)
        passport.expirationYear = 2030
        XCTAssert(passport.isValid)

        passport.passportID = "3456789"
        XCTAssertFalse(passport.isValid)
        passport.passportID = "0003456789"
        XCTAssertFalse(passport.isValid)
        passport.passportID = "ab3456789"
        XCTAssertFalse(passport.isValid)
        passport.passportID = "873456789"
        XCTAssert(passport.isValid)

        passport.height = "77.5in"
        XCTAssertFalse(passport.isValid)
        passport.height = "177.5cm"
        XCTAssertFalse(passport.isValid)
        passport.height = "76"
        XCTAssertFalse(passport.isValid)
        passport.height = "77in"
        XCTAssertFalse(passport.isValid)
        passport.height = "76in"
        XCTAssert(passport.isValid)
        passport.height = "194cm"
        XCTAssertFalse(passport.isValid)
        passport.height = "193cm"
        XCTAssert(passport.isValid)
        passport.height = "58in"
        XCTAssertFalse(passport.isValid)
        passport.height = "59in"
        XCTAssert(passport.isValid)
        passport.height = "149cm"
        XCTAssertFalse(passport.isValid)
        passport.height = "150cm"
        XCTAssert(passport.isValid)

        passport.eyeColor = "Blue"
        XCTAssertFalse(passport.isValid)
        passport.eyeColor = "hzl"
        XCTAssert(passport.isValid)
    }
}
