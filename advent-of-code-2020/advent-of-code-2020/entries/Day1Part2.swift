//
//  Day1Part2.swift
//  advent-of-code-2020
//
//  Created by Ryan Arana on 10/29/21.
//

import SwiftUI

class Day1Part2Entry: Entry {
    init() {
        super.init(year: 2020, day: 1, part: 2)
    }

    @Sendable override func run() async throws {
        let numbers: [Int]
        do {
            numbers = try await fileURL().lines.reduce(into: [Int]()) { (result, line) -> Void in
                guard let number = Int(line) else { return }
                result.append(number)
            }
        } catch {
            return
        }

        let answer = await run(for: numbers)
        DispatchQueue.main.async {
            self.answer = "\(answer)"
        }
    }

    func run(for input: [Int]) async -> Int {
        guard input.count >= 3 else { return 0 }

        for (i, a) in input[0..<input.endIndex - 2].enumerated() {
            for (ii, b) in input[0..<input.endIndex].enumerated() {
                guard ii != i else { continue }

                for (iii, c) in input[0..<input.endIndex].enumerated() {
                    guard iii != ii, iii != i else { continue }

                    if a + b + c == 2020 {
                        return a * b * c
                    }
                }
            }
        }

        return 0
    }
}
