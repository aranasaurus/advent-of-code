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
        
        for depth in input {
            if previous < depth {
                result += 1
            }
            previous = depth
            progress.completedUnitCount += 1
        }

        return result
    }
}
