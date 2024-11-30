//
//  Entry2021Day10.swift
//  AdventOfCode
//
//  Created by Ryan Arana on 12/9/21.
//

import Foundation

class Entry2021Day10: Entry {
    init(_ part: Part) {
        super.init(year: 2021, day: 10, part: part)
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
        defer { progress.completedUnitCount = progress.totalUnitCount }

        switch part {
        case .part1:
            let invalidCharacters = input
                .map(process(_:))
                .compactMap { (result: Result) -> UnicodeScalar? in
                    switch result {
                    case .invalidCharacter(let c):
                        return c
                    case .incompleteLine:
                        return nil
                    }
                }
            return invalidCharacters
                .compactMap({ part.scoreMap[$0] })
                .reduce(0, +)
        case .part2:
            let scores = input
                .map(process(_:))
                .compactMap { (result: Result) -> Int? in
                    switch result {
                    case .invalidCharacter:
                        return nil
                    case .incompleteLine(let closers):
                        return closers.reduce(0) { score, closer in
                            return (score * 5) + part.scoreMap[closer, default: 0]
                        }
                    }
                }
                .sorted()

            return scores[scores.count / 2]
        }
    }

    private func process<AnyString: StringProtocol>(_ line: AnyString) -> Result {
        let openers: [UnicodeScalar] = ["(", "[", "{", "<"]
        let closers: [UnicodeScalar] = [")", "]", "}", ">"]

        var opened = [UnicodeScalar]()
        for c in line.unicodeScalars {
            guard !opened.isEmpty else {
                if openers.contains(c) {
                    opened.append(c)
                } else {
                    return .invalidCharacter(c)
                }
                continue
            }

            guard let i = closers.firstIndex(of: c) else {
                opened.append(c)
                continue
            }

            if openers[i] == opened.last {
                opened.removeLast()
            } else {
                return .invalidCharacter(c)
            }
        }

        let remaining = opened
            .compactMap { openers.firstIndex(of: $0) }
            .reversed()
            .map { closers[$0] }
        return .incompleteLine(remaining)
    }
}

private enum Result {
    case invalidCharacter(UnicodeScalar)
    case incompleteLine([UnicodeScalar])
}

private extension Entry2021Day10.Part {
    var scoreMap: [UnicodeScalar: Int] {
        switch self {
        case .part1:
            return [
                ")": 3,
                "]": 57,
                "}": 1197,
                ">": 25137,
            ]
        case .part2:
            return [
                ")": 1,
                "]": 2,
                "}": 3,
                ">": 4,
            ]
        }
    }
}
