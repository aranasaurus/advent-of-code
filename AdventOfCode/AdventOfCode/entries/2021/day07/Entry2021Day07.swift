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
        return 0
    }
}
