//
//  Day1Part1.swift
//  advent-of-code-2020
//
//  Created by Ryan Arana on 10/29/21.
//

import SwiftUI

class Day1Part1Entry: Entry {
    init() {
        super.init(year: 2020, day: 1, part: 1)
    }

    @Sendable override func run() async throws {
        let numbers = try await fileURL().lines.reduce(into: [Int]()) { (result, line) -> Void in
            guard let number = Int(line) else { return }
            result.append(number)
        }

        let answer = await run(for: numbers)
        DispatchQueue.main.async {
            self.answer = "\(answer)"
        }
    }

    func run(for input: [Int]) async -> Int {
        guard input.count >= 2 else { return 0 }

        for (i, a) in input[0..<input.endIndex - 1].enumerated() {
            for b in input[i..<input.endIndex] {
                if a + b == 2020 {
                    return a * b
                }
            }
        }

        return 0
    }
}
