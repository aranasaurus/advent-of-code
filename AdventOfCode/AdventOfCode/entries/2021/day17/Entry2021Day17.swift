//
//  Entry2021Day17.swift
//  AdventOfCode
//
//  Created by Ryan Arana on 12/23/21.
//

import Foundation
import Collections

class Entry2021Day17: Entry {
    init(_ part: Part) {
        super.init(year: 2021, day: 17, part: part)
    }

    @Sendable override func run() async throws {
        let input = try String(contentsOf: try fileURL()).trimmingCharacters(in: .whitespacesAndNewlines)

        let answer = await run(for: input)
        DispatchQueue.main.async {
            self.answer = "\(answer)"
        }
    }

    func run(for input: String) async -> Int {
        let area = Area(string: input)
        switch part {
        case .part1:
            let launcher = Launcher(target: area)
            return launcher.bruteForceMaxY()
        case .part2:
            return 0
        }
    }
}

extension Entry2021Day17 {
    struct Vector {
        var x = 0
        var y = 0
    }

    struct Area {
        var xRange: ClosedRange<Int>
        var yRange: ClosedRange<Int>

        var left: Int { xRange.lowerBound }
        var right: Int { xRange.upperBound }
        var top: Int { yRange.upperBound }
        var bottom: Int { yRange.lowerBound }

        init(string: String) {
            // target area: x=235..259, y=-118..-62
            let xMinStart = string.index(after: string.firstIndex(of: "=")!)
            let xMinEnd = string.firstIndex(of: ".")!
            let xMaxStart = string.index(xMinEnd, offsetBy: 2)
            let xMaxEnd = string.index(string.firstIndex(of: "y")!, offsetBy: -2)

            let yMinStart = string.index(xMaxEnd, offsetBy: 4)
            let yMinEnd = string.index(string.lastIndex(of: ".")!, offsetBy: -1)
            let yMaxStart = string.index(yMinEnd, offsetBy: 2)
            let yMaxEnd = string.endIndex

            let xMin = Int(string[xMinStart..<xMinEnd])!
            let xMax = Int(string[xMaxStart..<xMaxEnd])!
            let yMin = Int(string[yMinStart..<yMinEnd])!
            let yMax = Int(string[yMaxStart..<yMaxEnd])!

            self.xRange = xMin...xMax
            self.yRange = yMin...yMax
        }

        func contains(_ point: Vector) -> Bool {
            xRange.contains(point.x) && yRange.contains(point.y)
        }
    }

    class Probe {
        var location = Vector()
        var velocity: Vector
        let startingVelocity: Vector
        let target: Area

        var maxY = 0
        var overshot = false

        var inTargetArea: Bool {
            target.contains(location)
        }

        var active: Bool { !overshot && !inTargetArea }

        var horizontalDistanceFromTarget: Int {
            guard !target.xRange.contains(location.x) else { return 0 }

            if location.x < target.left {
                return abs(location.x - target.left)
            } else {
                return abs(location.x - target.xRange.upperBound)
            }
        }

        init(target: Area, velocity: Vector) {
            self.target = target
            self.velocity = velocity
            self.startingVelocity = velocity
        }

        func launch() -> Bool {
            while active {
                advanceStep()
            }
            return inTargetArea
        }

        func advanceStep() {
            let previousHorizontalDistance = horizontalDistanceFromTarget

            // The probe's x position increases by its x velocity.
            location.x += velocity.x

            // The probe's y position increases by its y velocity.
            location.y += velocity.y

            // Due to drag, the probe's x velocity changes by 1 toward the value 0; that is, it decreases by 1
            // if it is greater than 0, increases by 1 if it is less than 0, or does not change if it is
            // already 0.
            if velocity.x < 0 {
                velocity.x += 1
            } else if velocity.x > 0 {
                velocity.x -= 1
            }

            // Due to gravity, the probe's y velocity decreases by 1.
            velocity.y -= 1

            // update state
            maxY = max(maxY, location.y)

            if location.y < target.bottom && velocity.y <= 0 {
                // If we're below the target and already not going up, gravity will ensure that we never make it
                overshot = true
            } else if velocity.x == 0 && !target.xRange.contains(location.x) {
                // If we've drug to 0 x-velocity and we're not within the target's x bounds, we never will be.
                overshot = true
            } else {
                // if our horizontal distance is increasing, we're going the wrong way!
                overshot = horizontalDistanceFromTarget > previousHorizontalDistance
            }
        }
    }

    class Launcher {
        let target: Area

        var successfulProbes = [Probe]()

        init(target: Area) {
            self.target = target
        }

        func bruteForceMaxY() -> Int {
            let probes = (1...200).map { x in
                (0...200).map { y in
                    [
                        Probe(target: target, velocity: Vector(x: x, y: y)),
                        Probe(target: target, velocity: Vector(x: -x, y: y))
                    ]
                }.flatMap({ $0 })
            }.flatMap({ $0 })

            for probe in probes {
                if probe.launch() {
                    successfulProbes.append(probe)
                }
            }

            return successfulProbes.max(by: { $0.maxY < $1.maxY })?.maxY ?? .min
        }
    }
}
