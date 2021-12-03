//
//  Entry2021Day03.swift
//  AdventOfCode
//
//  Created by Ryan Arana on 12/3/21.
//

import Foundation

class Entry2021Day03: Entry {
    init(_ part: Part) {
        super.init(year: 2021, day: 3, part: part)
    }

    @Sendable override func run() async throws {
        let inputLines = try String(contentsOf: try fileURL())
            .split(separator: "\n", omittingEmptySubsequences: true)
            .map(String.init(_:))

        progress.totalUnitCount = Int64(inputLines.count)
        let answer = await run(for: inputLines)
        DispatchQueue.main.async {
            self.answer = "\(answer)"
        }
    }

    func run(for input: [String]) async -> Int {
        var gamma = 0
        var epsilon = 0

        switch part {
        case .part1:
            var bits = [Int]()
            let half = Int((Double(input.count) / 2).rounded(.down))

            progress.totalUnitCount += 1
            for line in input {
                defer { progress.completedUnitCount += 1 }

                for (i, bit) in line.enumerated() {
                    if bits.count == i {
                        bits.append(0)
                    }

                    guard bits[i] < half, bit == "1" else { continue }
                    bits[i] += 1
                }
            }

            let bitMask = bits.count - 1
            gamma = bits.enumerated().reduce(0) { (result, item) -> Int in
                let bit = item.element >= half ? 1 : 0
                let offset = bitMask - item.offset

                return result + (bit << offset)
            }

            epsilon = ~gamma & ((1 << bitMask) - 1)
            progress.completedUnitCount += 1
        case .part2:
            for line in input {
                defer { progress.completedUnitCount += 1 }
            }
        }

        return gamma * epsilon
    }
}
