//
//  Entry2020Day05.swift
//  AdventOfCode
//
//  Created by Ryan Arana on 11/5/21.
//

import Foundation

class Entry2020Day05: Entry {
    init(_ part: Part) {
        super.init(year: 2020, day: 5, part: part)
    }

    @Sendable override func run() async throws {
        let lines = try String(contentsOf: try fileURL()).split(separator: "\n", omittingEmptySubsequences: false).map(String.init(_:))

        progress.totalUnitCount = Int64(lines.count)
        let answer = await run(for: lines)
        DispatchQueue.main.async {
            self.answer = "\(answer)"
        }
    }

    func run(for input: [String]) async -> Int {
        switch part {
        case .part1:
            return input.reduce(0) { result, line in
                progress.completedUnitCount += 1
                return max(result, parse(line: line))
            }
        case .part2:
            return 0
        }
    }

    func parse(line: String) -> Int {
        let numbers = [
            512, 256, 128, 64, 32, 16, 8, 4, 2, 1
        ]

        var result = 0
        for (number, character) in zip(numbers, line) {
            if character == "B" || character == "R" {
                result += number
            }
        }
        return result
    }
}
