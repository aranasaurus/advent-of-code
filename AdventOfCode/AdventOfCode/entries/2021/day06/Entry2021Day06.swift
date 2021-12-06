//
//  Entry2021Day06.swift
//  AdventOfCode
//
//  Created by Ryan Arana on 12/6/21.
//

import Foundation

class Entry2021Day06: Entry {
    init(_ part: Part) {
        super.init(year: 2021, day: 6, part: part)
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
        let fishies = input
            .split(separator: ",")
            .compactMap(Int.init(_:))

        progress.totalUnitCount = Int64(part.days)

        var spawnCounts = Array(repeating: 0, count: 9)
        for fish in fishies {
            spawnCounts[fish] += 1
        }

        for _ in 1...part.days {
            defer { progress.completedUnitCount += 1 }

            /* Each day, a 0 becomes a 6 and adds a new 8 to the end of the list, while each other
             number decreases by 1 if it was present at the start of the day.
             */

            let newSpawns = spawnCounts[0]
            for i in 1...6 {
                spawnCounts[i-1] = spawnCounts[i]
            }
            spawnCounts[6] = newSpawns + spawnCounts[7]
            spawnCounts[7] = spawnCounts[8]
            spawnCounts[8] = newSpawns
        }
        return spawnCounts.reduce(0, +)
    }
}

private extension Entry.Part {
    var days: Int {
        switch self {
        case .part1: return 80
        case .part2: return 256
        }
    }
}
