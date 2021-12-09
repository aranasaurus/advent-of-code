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
        progress.totalUnitCount = Int64(input.count)

        return 0
    }
}
