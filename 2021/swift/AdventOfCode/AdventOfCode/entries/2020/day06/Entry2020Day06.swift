//
//  Entry2020Day06.swift
//  AdventOfCode
//
//  Created by Ryan Arana on 11/6/21.
//

import Foundation

class Entry2020Day06: Entry {
    init(_ part: Part) {
        super.init(year: 2020, day: 6, part: part)
    }

    @Sendable override func run() async throws {
        let chunks = try String(contentsOf: try fileURL())
            .split(separator: "\n", omittingEmptySubsequences: false)
            .map(String.init(_:))
            .chunked

        progress.totalUnitCount = Int64(chunks.count)
        let answer = await run(for: chunks)
        DispatchQueue.main.async {
            self.answer = "\(answer)"
        }
    }

    func run(for input: [[String]]) async -> Int {
        input.reduce(0) { result, chunk in
            progress.completedUnitCount += 1
            return result + parse(chunk: chunk)
        }
    }

    func parse(chunk: [String]) -> Int {
        let individualAnswers = Set(chunk.joined())
        switch part {
        case .part1:
            return individualAnswers.count
        case .part2:
            return individualAnswers
                .filter({ answer in
                    chunk.allSatisfy({ $0.contains(answer) })
                })
                .count
        }
    }
}
