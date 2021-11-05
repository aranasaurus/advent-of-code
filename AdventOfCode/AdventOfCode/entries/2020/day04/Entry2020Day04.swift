//
//  Entry2020Day04.swift
//  AdventOfCode
//
//  Created by Ryan Arana on 11/3/21.
//

import Foundation

class Entry2020Day04: Entry {
    init(_ part: Part) {
        super.init(year: 2020, day: 4, part: part)
    }

    @Sendable override func run() async throws {
        progress.totalUnitCount = Int64(3)
        let lines = try String(contentsOf: try fileURL()).split(separator: "\n", omittingEmptySubsequences: false).map(String.init(_:))

        progress.completedUnitCount = 1
        let answer = await run(for: lines)
        DispatchQueue.main.async {
            self.answer = "\(answer)"
        }
    }

    func run(for input: [String]) async -> Int {
        switch part {
        case .part1:
            return await runKeyCounter(for: input)
        case .part2:
            return await runPassportParser(for: input)
        }
    }

    func runKeyCounter(for input: [String]) async -> Int {
        let chunks = chunk(input)
        progress.completedUnitCount += 1
        progress.totalUnitCount += Int64(chunks.count)

        let requiredKeys = Set([
            "byr:",
            "iyr:",
            "eyr:",
            "hgt:",
            "hcl:",
            "ecl:",
            "pid:"
        ])

        var validChunks = 0
        for chunk in chunks {
            var foundRequiredKeys = Set<String>()
            for key in requiredKeys {
                if chunk.firstIndex(where: { $0.contains(key) }) != nil {
                    foundRequiredKeys.insert(key)
                }
            }

            if foundRequiredKeys == requiredKeys {
                validChunks += 1
            }
            progress.completedUnitCount += 1
        }
        progress.completedUnitCount += 1
        return validChunks
    }

    func runPassportParser(for input: [String]) async -> Int {
        let chunks = chunk(input)
        progress.completedUnitCount += 1
        let validPassports = chunks.compactMap(Passport.parse(lines:))
        progress.completedUnitCount += 1
        return validPassports.filter({ $0.isValid }).count
    }

    func chunk(_ lines: [String]) -> [[String]] {
        var result = [[String]]()

        var currentChunk = [String]()
        for line in lines {
            if line.isEmpty {
                result.append(currentChunk)
                currentChunk.removeAll()
            } else {
                currentChunk.append(line)
            }
        }
        if !currentChunk.isEmpty {
            result.append(currentChunk)
        }

        return result
    }
}

extension Entry2020Day04 {
    struct Passport: Equatable {
        enum CodingKeys: String, CaseIterable, Equatable {
            case birthYear = "byr"
            case issueYear = "iyr"
            case expirationYear = "eyr"
            case height = "hgt"
            case hairColor = "hcl"
            case eyeColor = "ecl"
            case passportID = "pid"
            case countryID = "cid"
        }

        static func parse<T: StringProtocol>(pair: T) -> (key: CodingKeys, value: String)? {
            let split = pair.split(separator: ":")

            guard split.count == 2, let key = CodingKeys(rawValue: String(split[0])) else {
                return nil
            }

            return (key, String(split[1]))
        }

        static func parse(lines: [String]) -> Passport? {
            var birthYear: Int?
            var issueYear: Int?
            var expirationYear: Int?
            var height: String?
            var hairColor: String?
            var eyeColor: String?
            var countryID: Int?
            var passportID: String?

            for line in lines {
                let pairStrings = line.split(separator: " ")
                for pairString in pairStrings {
                    if let pair = parse(pair: pairString) {
                        switch pair.key {
                        case .birthYear:
                            guard let year = Int(pair.value) else {
                                print("Invalid Passport: (birthYear) \(lines)")
                                return nil
                            }
                            birthYear = year
                        case .issueYear:
                            guard let year = Int(pair.value) else {
                                print("Invalid Passport: (issueYear) \(lines)")
                                return nil
                            }
                            issueYear = year
                        case .expirationYear:
                            guard let year = Int(pair.value) else {
                                print("Invalid Passport: (expirationYear) \(lines)")
                                return nil
                            }
                            expirationYear = year
                        case .height:
                            height = pair.value
                        case .hairColor:
                            hairColor = pair.value
                        case .eyeColor:
                            eyeColor = pair.value
                        case .passportID:
                            passportID = pair.value
                        case .countryID:
                            countryID = Int(pair.value)
                        }
                    }
                }
            }

            guard let birthYear = birthYear,
                  let issueYear = issueYear,
                  let expirationYear = expirationYear,
                  let height = height,
                  let hairColor = hairColor,
                  let eyeColor = eyeColor,
                  let passportID = passportID
            else {
                print("Invalid Passport: \(lines)")
                return nil
            }

            return Passport(
                birthYear: birthYear,
                issueYear: issueYear,
                expirationYear: expirationYear,
                height: height,
                hairColor: hairColor,
                eyeColor: eyeColor,
                passportID: passportID,
                countryID: countryID
            )
        }

        var birthYear: Int
        var issueYear: Int
        var expirationYear: Int
        var height: String
        var hairColor: String
        var eyeColor: String
        var passportID: String
        var countryID: Int?

        var isValid: Bool {
            // byr (Birth Year) - four digits; at least 1920 and at most 2002.
            guard (1920...2002).contains(birthYear) else { return false }

            // iyr (Issue Year) - four digits; at least 2010 and at most 2020.
            guard (2010...2020).contains(issueYear) else { return false }

            // eyr (Expiration Year) - four digits; at least 2020 and at most 2030.
            guard (2020...2030).contains(expirationYear) else { return false }

            // pid (Passport ID) - a nine-digit number, including leading zeroes.
            guard passportID.count == 9, Int(passportID) != nil else { return false }

            // hgt (Height) - a number followed by either cm or in:
            // If cm, the number must be at least 150 and at most 193.
            // If in, the number must be at least 59 and at most 76.
            if height.contains("cm") {
                guard let h = Int(height.replacingOccurrences(of: "cm", with: "")), (150...193).contains(h) else { return false }
            } else if height.contains("in") {
                guard let h = Int(height.replacingOccurrences(of: "in", with: "")), (59...76).contains(h) else { return false }
            } else {
                return false
            }

            // hcl (Hair Color) - a # followed by exactly six characters 0-9 or a-f.
            guard hairColor.range(of: #"#(?:[0-9a-fA-F]{6})"#, options: .regularExpression) != nil else { return false }

            // ecl (Eye Color) - exactly one of: amb blu brn gry grn hzl oth.
            enum EyeColor: String {
                case amber = "amb"
                case blue = "blu"
                case brown = "brn"
                case gray = "gry"
                case green = "grn"
                case hazel = "hzl"
                case other = "oth"
            }
            guard EyeColor(rawValue: eyeColor) != nil else { return false }

            // cid (Country ID) - ignored, missing or not.
            return true
        }
    }
}
