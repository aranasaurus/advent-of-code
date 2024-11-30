//
//  Entry2021Day15.swift
//  AdventOfCode
//
//  Created by Ryan Arana on 12/16/21.
//

import Foundation
import Collections

class Entry2021Day15: Entry {
    var grid: Grid
    var path = [Point]()
    var pointsProcessed = 0

    init(_ part: Part) {
        grid = Grid([""], tiles: 0)
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
        grid = Grid(input, tiles: part.tiles)
        var frontier = Heap([grid.start])
        var cameFrom = [Point: Point]()

        pointsProcessed = 0
        while let current = frontier.popMin() {
            pointsProcessed += 1
            guard current !== grid.end else { break }

            for next in grid.neighbors(for: current) {
                let newCost = current.costToGetHere + next.risk
                if !cameFrom.keys.contains(next) || newCost < next.costToGetHere {
                    next.costToGetHere = newCost
                    frontier.insert(next)
                    cameFrom[next] = current
                }
            }
        }

        var current = grid.end
        path = [current]
        while let next = cameFrom[current], next !== grid.start {
            path.append(next)
            current = next
        }
        return grid.end.costToGetHere
    }
}

extension Entry2021Day15 {
    struct Grid: CustomDebugStringConvertible {
        let grid: [[Point]]

        var start: Point { grid.first!.first! }
        var end: Point { grid.last!.last! }

        var debugDescription: String {
            grid.map { row in
                row.map { "\($0.risk)" }
                .joined(separator: "")
            }
            .joined(separator: "\n")
        }

        init<AnyString: StringProtocol>(_ input: [AnyString], tiles: Int) {
            let rowCount = input.count
            let colCount = input.first!.count

            let risks = input.map { rowString in
                rowString
                    .unicodeScalars
                    .map(String.init(_:))
                    .compactMap(Int.init(_:))
            }

            var grid = [[Point]]()
            for vTile in 0..<tiles {
                for (riskY, riskRow) in risks.enumerated() {
                    var row = [Point]()
                    for hTile in 0..<tiles {
                        for (riskX, risk) in riskRow.enumerated() {
                            let x = (hTile * colCount) + riskX
                            let y = (vTile * rowCount) + riskY
                            var modifiedRisk = risk + vTile + hTile
                            if modifiedRisk > 9 {
                                modifiedRisk -= 9
                            }

                            let point = Point(risk: modifiedRisk, x: x, y: y)
                            row.append(point)
                        }
                    }
                    grid.append(row)
                }
            }

            if !grid.isEmpty {
                grid[0][0].costToGetHere = 0
            }

            self.grid = grid
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

    class Point: Hashable, Comparable {
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

        var priority: Int { costToGetHere }

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
}

extension Entry2021Day15.Part {
    var tiles: Int {
        switch self {
        case .part1: return 1
        case .part2: return 5
        }
    }
}
