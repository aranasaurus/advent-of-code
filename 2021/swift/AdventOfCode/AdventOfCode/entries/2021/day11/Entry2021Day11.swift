//
//  Entry2021Day11.swift
//  AdventOfCode
//
//  Created by Ryan Arana on 12/11/21.
//

import Foundation

class Entry2021Day11: Entry {
    init(_ part: Part) {
        super.init(year: 2021, day: 11, part: part)
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
        let energies = input
            .map {
                $0.unicodeScalars
                    .map(String.init(_:))
                    .compactMap(Int.init(_:))
            }

        let octopusMap = energies.map { $0.map(Octopus.init(energy:)) }
        // populate Octopus.adjacents
        for (y, row) in octopusMap.enumerated() {
            for (x, octopus) in row.enumerated() {
                let isLeftEdge = x == 0
                let isRightEdge = x == row.count - 1
                if y > 0 {
                    if !isLeftEdge {
                        octopus.adjacents.append(octopusMap[y-1][x-1])
                    }
                    octopus.adjacents.append(octopusMap[y-1][x])
                    if !isRightEdge {
                        octopus.adjacents.append(octopusMap[y-1][x+1])
                    }
                }


                if !isLeftEdge {
                    octopus.adjacents.append(row[x-1])
                }

                if !isRightEdge {
                    octopus.adjacents.append(row[x+1])
                }

                if y < octopusMap.count - 1 {
                    if !isLeftEdge {
                        octopus.adjacents.append(octopusMap[y+1][x-1])
                    }
                    octopus.adjacents.append(octopusMap[y+1][x])
                    if !isRightEdge {
                        octopus.adjacents.append(octopusMap[y+1][x+1])
                    }
                }
            }
        }
        let octopi = octopusMap.flatMap({ $0 })

        switch part {
        case .part1:
            progress.totalUnitCount = 100
            var flashes = 0
            let steps = 100
            for _ in 1...steps {
                flashes += advanceStepCountingFlashes(in: octopi)
            }
            return flashes
        case .part2:
            var step = 1
            while advanceStepCountingFlashes(in: octopi) != octopi.count {
                step += 1
            }
            return step
        }
    }

    private func advanceStepCountingFlashes(in octopi: [Octopus]) -> Int {
        for octopus in octopi {
            octopus.startStep()
        }

        while !octopi.filter({ $0.waitingToFlash }).isEmpty {
            for octopus in octopi {
                octopus.flashIfNeeded()
            }
        }

        return octopi.filter { $0.hasFlashed }.count
    }
}

private class Octopus {
    private(set) var energy: Int
    var adjacents = [Octopus]()

    var hasFlashed = false
    var waitingToFlash: Bool {
        energy > 9 && !hasFlashed
    }

    init(energy: Int) {
        self.energy = energy
    }

    func startStep() {
        if energy > 9 {
            energy = 0
        }

        hasFlashed = false
        energy += 1
    }

    func flashIfNeeded() {
        guard waitingToFlash else { return }

        hasFlashed = true

        for adjacent in adjacents {
            adjacent.energy += 1
        }

        return
    }
}
