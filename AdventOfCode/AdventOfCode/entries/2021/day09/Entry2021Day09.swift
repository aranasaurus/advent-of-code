//
//  Entry2021Day09.swift
//  AdventOfCode
//
//  Created by Ryan Arana on 12/9/21.
//

import Foundation

class Entry2021Day09: Entry {
    init(_ part: Part) {
        super.init(year: 2021, day: 9, part: part)
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
        progress.totalUnitCount = Int64(input.count + 1)

        var heightMap = [[Int]]()
        for line in input {
            let row = line
                .unicodeScalars
                .map(String.init(_:))
                .compactMap(Int.init(_:))
            heightMap.append(row)
            progress.completedUnitCount += 1
        }

        var riskFactors = [Int]()

        for (rowIndex, row) in heightMap.enumerated() {
            for (i, current) in row.enumerated() {
                var left = Int.max
                var right = Int.max
                var above = Int.max
                var below = Int.max

                if i > 0 {
                    left = heightMap[rowIndex][i-1]
                }

                if i < row.count - 1 {
                    right = heightMap[rowIndex][i+1]
                }

                if rowIndex > 0 {
                    above = heightMap[rowIndex-1][i]
                }

                if rowIndex < heightMap.count - 1 {
                    below = heightMap[rowIndex+1][i]
                }

                let heights = Set([left, right, above, below]).subtracting([current, Int.max])
                if !heights.isEmpty && heights.allSatisfy({ $0 > current }) {
                    riskFactors.append(current + 1)
                    // Helpful print to find edgecases
//                    print(
//                        """
//                        \(i), \(rowIndex)
//                              \(above == Int.max ? -1 : above)
//                            \(left == Int.max ? -1 : left) \(current) \(right == Int.max ? -1 : right)
//                              \(below == Int.max ? -1 : below)
//                        """
//                    )
                }
            }
            progress.completedUnitCount += 1
        }
        return riskFactors.reduce(0, +)
    }
}
