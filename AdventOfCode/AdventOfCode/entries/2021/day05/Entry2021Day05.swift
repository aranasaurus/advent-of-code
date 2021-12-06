//
//  Entry2021Day05.swift
//  AdventOfCode
//
//  Created by Ryan Arana on 12/5/21.
//

import Foundation

class Entry2021Day05: Entry {
    init(_ part: Part) {
        super.init(year: 2021, day: 5, part: part)
    }

    @Sendable override func run() async throws {
        let inputLines = try String(contentsOf: try fileURL())
            .split(separator: "\n")

        progress.totalUnitCount = Int64(inputLines.count)
        let answer = await run(for: inputLines)
        DispatchQueue.main.async {
            self.answer = "\(answer)"
        }
    }

    func run<AnyString: StringProtocol>(for input: [AnyString]) async -> Int {
        switch part {
        case .part1:
            return 0
        case .part2:
            return 0
        }
    }
}
