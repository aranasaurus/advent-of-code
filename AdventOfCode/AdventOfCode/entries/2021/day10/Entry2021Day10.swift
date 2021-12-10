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

        let invalidCharacters = input.compactMap(firstInvalidCharacter(in:))
        let scoreMap = [
            UnicodeScalar(")"): 3,
            "]": 57,
            "}": 1197,
            ">": 25137,
        ]
        return invalidCharacters
            .compactMap({ scoreMap[$0] })
            .reduce(0, +)
    }

    func firstInvalidCharacter<AnyString: StringProtocol>(in line: AnyString) -> UnicodeScalar? {
        let openers: [UnicodeScalar] = ["(", "[", "{", "<"]
        let closers: [UnicodeScalar] = [")", "]", "}", ">"]

        var opened = [UnicodeScalar]()
        for c in line.unicodeScalars {
            guard !opened.isEmpty else {
                if openers.contains(c) {
                    opened.append(c)
                } else {
                    return c
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
                return c
            }
        }

        return nil
    }
}
