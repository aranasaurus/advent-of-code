//
//  Entry2021Day08.swift
//  AdventOfCode
//
//  Created by Ryan Arana on 12/8/21.
//

import Foundation

class Entry2021Day08: Entry {
    init(_ part: Part) {
        super.init(year: 2021, day: 8, part: part)
    }

    @Sendable override func run() async throws {
        let inputs = try String(contentsOf: try fileURL())
            .split(separator: "\n")

        let answer = await run(for: inputs)
        DispatchQueue.main.async {
            self.answer = "\(answer)"
        }
    }

    func run<AnyString: StringProtocol>(for input: [AnyString]) async -> Int {
        progress.totalUnitCount = Int64(input.count)

        return input.reduce(0) { result, line in
            defer { progress.completedUnitCount += 1 }

            guard let display = Display(line: line) else { return result }

            switch part {
            case .part1:
                let digits = [display.digitToOutputMap[1], display.digitToOutputMap[4], display.digitToOutputMap[7], display.digitToOutputMap[8]]
                return digits.reduce(result) { occurrences, digit in
                    occurrences + display.outputStrings
                        .filter { $0 == digit }
                        .count
                }
            case .part2:
                return result + display.outputDigits
            }
        }
    }
}

extension Entry2021Day08 {
    struct Display {
        let digitToOutputMap: [String]
        let outputToDigitMap: [String: Int]
        let outputStrings: [String]
        let outputDigits: Int

        init?<AnyString: StringProtocol>(line: AnyString) {
            let sides = line.split(separator: "|")
            let sequences = sides[0].split(separator: " ")
                .map { String($0.sorted()) }
            outputStrings = sides[1].split(separator: " ")
                .map { String($0.sorted()) }

            guard
                let one = sequences.first(where: { $0.count == 2 }),
                let four = sequences.first(where: { $0.count == 4 }),
                let seven = sequences.first(where: { $0.count == 3 }),
                let eight = sequences.first(where: { $0.count == 7 }),
                let six = sequences.first(where: {
                    $0.count == 6
                    && Set($0).subtracting(one).count == 5
                }),
                let nine = sequences.first(where: {
                    $0 != six
                    && $0.count == 6
                    && Set($0).subtracting(four).count == 2
                }),
                let zero = sequences.first(where: {
                    $0 != six
                    && $0 != nine
                    && $0.count == 6
                }),
                let five = sequences.first(where: {
                    $0.count == 5
                    && Set($0).subtracting(six).count == 0
                }),
                let two = sequences.first(where: {
                    $0 != five
                    && $0.count == 5
                    && Set($0).subtracting(five).count == 2
                }),
                let three = sequences.first(where: {
                    $0 != five
                    && $0 != two
                    && $0.count == 5
                })
            else { return nil }

            digitToOutputMap = [
                zero,
                one,
                two,
                three,
                four,
                five,
                six,
                seven,
                eight,
                nine
            ]
            outputToDigitMap = [
                zero: 0,
                one: 1,
                two: 2,
                three: 3,
                four: 4,
                five: 5,
                six: 6,
                seven: 7,
                eight: 8,
                nine: 9
            ]

            var result = ""
            for outputString in outputStrings{
                result += "\(outputToDigitMap[outputString, default: 0])"
            }

            outputDigits = Int(result)!
        }
    }
}
