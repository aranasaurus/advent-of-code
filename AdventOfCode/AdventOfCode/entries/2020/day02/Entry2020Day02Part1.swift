//
//  Entry2020Day02Part1.swift
//  AdventOfCode
//
//  Created by Ryan Arana on 10/29/21.
//

import SwiftUI

class Entry2020Day02Part1: Entry {
    struct Components {
        var occurrenceRange: ClosedRange<Int>
        var letter: String
        var password: String

        init?(line: String) {
            let colonStrings = line.split(separator: ":")
            guard colonStrings.count == 2 else { return nil }

            password = String(colonStrings[1]).trimmingCharacters(in: .whitespacesAndNewlines)

            let rules = colonStrings[0].split(separator: " ")
            guard rules.count == 2 else { return nil }

            letter = String(rules[1])

            let numbers = rules[0].split(separator: "-")
            guard numbers.count == 2, let start = Int(numbers[0]), let end = Int(numbers[1]) else { return nil }

            occurrenceRange = start...end
        }

        var valid: Bool {
            occurrenceRange.contains(password.filter { String($0) == letter }.count)
        }
    }

    init() {
        super.init(year: 2020, day: 2, part: 1)
    }

    @Sendable override func run() async throws {
        let components = try await fileURL().lines.reduce(into: [Components]()) { (result, line) -> Void in
            guard let components = Components(line: line) else { return }
            result.append(components)
        }

        progress.totalUnitCount = Int64(components.count)

        let answer = await run(for: components)
        DispatchQueue.main.async {
            self.answer = Entry.formatter.string(from: NSNumber(value: answer))
        }
    }

    func run(for input: [Components]) async -> Int {
        input.filter {
            progress.completedUnitCount += 1
            return $0.valid
        }.count
    }

}
