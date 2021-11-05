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
        let chunks = chunk(input)
        progress.completedUnitCount += 1
        let validPassports = chunks.compactMap(Passport.parse(lines:))
        progress.completedUnitCount += 1
        return validPassports.count
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
            var passportID: Int?

            for line in lines {
                let pairStrings = line.split(separator: " ")
                for pairString in pairStrings {
                    if let pair = parse(pair: pairString) {
                        switch pair.key {
                        case .birthYear:
                            guard let year = Int(pair.value) else { return nil }
                            birthYear = year
                        case .issueYear:
                            guard let year = Int(pair.value) else { return nil }
                            issueYear = year
                        case .expirationYear:
                            guard let year = Int(pair.value) else { return nil }
                            expirationYear = year
                        case .height:
                            height = pair.value
                        case .hairColor:
                            hairColor = pair.value
                        case .eyeColor:
                            eyeColor = pair.value
                        case .passportID:
                            guard let id = Int(pair.value) else { return nil }
                            passportID = id
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
        var passportID: Int
        var countryID: Int?
    }
}
