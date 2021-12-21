//
//  Entry2021Day15.swift
//  AdventOfCode
//
//  Created by Ryan Arana on 12/16/21.
//

import Foundation
import Collections

class Entry2021Day15: Entry {
    init(_ part: Part) {
        super.init(year: 2021, day: 15, part: part)
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
        switch part {
        case .part1:
            let grid = Grid(input)
            var frontier = Heap([grid.start])
            var cameFrom = [Point: Point]()

            var counter = 0
            while let current = frontier.popMin() {
                counter += 1
                guard current !== grid.end else { break }

                for next in grid.neighbors(for: current) {
                    let newCost = current.costToGetHere + next.risk
                    if !cameFrom.keys.contains(next) || newCost < next.costToGetHere {
                        next.costToGetHere = newCost
                        if next.estimatedCostToEnd == .max {
                            next.estimatedCostToEnd = abs(next.x - grid.end.x) + abs(next.y - grid.end.y)
                        }
                        frontier.insert(next)
                        cameFrom[next] = current
                    }
                }
            }

            var current = grid.end
            var path = [current]
            while let next = cameFrom[current], next !== grid.start {
                path.append(next)
                current = next
            }
            print(path.reversed().map( { $0.debugDescription }).joined(separator: "\n"))
            print("\(counter) points processed.")
            return path.reduce(0) { $0 + $1.risk }
        case .part2:
            return 0
        }
    }
}

private struct Grid {
    let grid: [[Point]]

    var start: Point { grid.first!.first! }
    var end: Point { grid.last!.last! }

    init<AnyString: StringProtocol>(_ input: [AnyString]) {
        self.grid = input
            .enumerated()
            .map { rowIndex, rowString in
                rowString
                    .unicodeScalars
                    .map(String.init(_:))
                    .compactMap(Int.init(_:))
                    .enumerated()
                    .map {
                        let point = Point(risk: $0.element, x: $0.offset, y: rowIndex)
                        if point.x == 0 && point.y == 0 {
                            point.costToGetHere = 0
                            point.estimatedCostToEnd = 0
                        }
                        return point
                    }
            }
    }

    func neighbors(for point: Point) -> [Point] {
        var neighbors = [Point]()

        if point.x > 0 {
            neighbors.append(grid[point.y][point.x-1])
        }

        if point.x < grid[point.y].count - 1 {
            neighbors.append(grid[point.y][point.x+1])
        }

        if point.y > 0 {
            neighbors.append(grid[point.y-1][point.x])
        }

        if point.y < grid.count - 1 {
            neighbors.append(grid[point.y+1][point.x])
        }

        return neighbors
    }
}

private class Point: Hashable, Comparable {
    static func == (lhs: Point, rhs: Point) -> Bool {
        lhs === rhs
    }

    static func < (lhs: Point, rhs: Point) -> Bool {
        lhs.priority < rhs.priority
    }

    var debugDescription: String {
        "[\(x), \(y)]: \(risk) | \(costToGetHere)"
    }

    var risk: Int
    var x: Int
    var y: Int
    var costToGetHere = Int.max
    var estimatedCostToEnd = Int.max

    var priority: Int { costToGetHere + estimatedCostToEnd }

    init(risk: Int, x: Int, y: Int) {
        self.risk = risk
        self.x = x
        self.y = y
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
    }
}
