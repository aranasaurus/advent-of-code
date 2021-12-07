//
//  Entry2021Day07.swift
//  AdventOfCode
//
//  Created by Ryan Arana on 12/7/21.
//

import Foundation

class Entry2021Day07: Entry {
    init(_ part: Part) {
        super.init(year: 2021, day: 7, part: part)
    }

    @Sendable override func run() async throws {
        let inputs = try String(contentsOf: try fileURL())
            .trimmingCharacters(in: .whitespacesAndNewlines)

        let answer = await run(for: inputs)
        DispatchQueue.main.async {
            self.answer = "\(answer)"
        }
    }

    func run<AnyString: StringProtocol>(for input: AnyString) async -> Int {
        progress.totalUnitCount = Int64(2)

        let positions = input
            .split(separator: ",")
            .compactMap(Int.init(_:))
            .sorted()

        progress.completedUnitCount = 1

        let median: Int
        let midIndex = positions.count / 2
        if positions.count.isMultiple(of: 2) {
            median = positions[midIndex-1...midIndex].reduce(0, +) / 2
        } else {
            median = positions[midIndex]
        }

        defer { progress.completedUnitCount = progress.totalUnitCount }
        
        return positions.reduce(0) { result, position in
            result + (abs(position - median))
        }
    }
}
