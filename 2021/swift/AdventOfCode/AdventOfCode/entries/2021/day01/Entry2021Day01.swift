//
//  Entry2021Day01.swift
//  AdventOfCode
//
//  Created by Ryan Arana on 12/1/21.
//

import Foundation

class Entry2021Day01: Entry {
    init(_ part: Part) {
        super.init(year: 2021, day: 1, part: part)
    }

    @Sendable override func run() async throws {
        let depths = try String(contentsOf: try fileURL())
            .split(separator: "\n", omittingEmptySubsequences: false)
            .map(String.init(_:))
            .compactMap(Int.init(_:))

        progress.totalUnitCount = Int64(depths.count)
        let answer = await run(for: depths)
        DispatchQueue.main.async {
            self.answer = "\(answer)"
        }
    }

    func run(for input: [Int]) async -> Int {
        var previous = Int.max
        var result = 0

        switch part {
        case .part1:
            for depth in input {
                if depth > previous {
                    result += 1
                }
                previous = depth
                progress.completedUnitCount += 1
            }

        case .part2:
            var window = [Int]()

            for depth in input {
                defer { progress.completedUnitCount += 1 }

                // pop the 3rd depth from the window before pushing the new one on if we're beyond the first two depths.
                if window.count == 3 {
                    window.removeLast()
                }

                window.insert(depth, at: 0)

                // For the first two depths we just want to insert them and continue
                guard window.count == 3 else {
                    continue
                }

                // we have a full set, check if it's bigger than the previous set (first set will automatically be ignored because we start previous at Int.max.
                let windowSum = window.reduce(0, +)

                if windowSum > previous {
                    result += 1
                }

                // Save this sum as the previous
                previous = windowSum
            }
        }

        return result
    }
}
