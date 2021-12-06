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
        var fishies = input
            .split(separator: ",")
            .compactMap(Int.init(_:))

        progress.totalUnitCount = 80
        for _ in 1...80 {
            defer { progress.completedUnitCount += 1 }
            
            /* Each day, a 0 becomes a 6 and adds a new 8 to the end of the list, while each other
             number decreases by 1 if it was present at the start of the day.
             */
            for (i, var fish) in fishies.enumerated() {
                switch fish {
                case 0:
                    fish = 6
                    fishies.append(8)
                default:
                    fish -= 1
                }

                fishies[i] = fish
            }
        }
        return fishies.count
    }
}
