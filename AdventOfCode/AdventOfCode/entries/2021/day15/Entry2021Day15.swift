//
//  Entry2021Day15.swift
//  AdventOfCode
//
//  Created by Ryan Arana on 12/16/21.
//

import Foundation

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
            var grid = [[Point]]()
            for (rowIndex, rowString) in input.enumerated() {
                var row = [Point]()
                for risk in rowString.unicodeScalars.map(String.init(_:)).compactMap(Int.init(_:)).enumerated() {
                    let point = Point(risk: risk.element, x: risk.offset, y: rowIndex)
                    if let left = row.last {
                        point.neighbors.append(left)
                        left.neighbors.append(point)
                    }
                    row.append(point)
                }
                grid.append(row)
            }

            for row in grid.enumerated() {
                let aboveRow = row.offset > 0 ? grid[row.offset - 1] : nil
                for point in row.element.enumerated() {
                    if let above = aboveRow?[point.offset] {
                        point.element.neighbors.append(above)
                        above.neighbors.append(point.element)
                    }

                    point.element.neighbors.sort(by: { $0.risk < $1.risk })
                }
            }

            let start = grid.first!.first!
            start.g = 0
            start.h = 0

            let end = grid.last!.last!
            var open = PriorityQueue([start])
            var closed = [Point]()

            while let current = open.pop() {
                closed.append(current)

                guard current !== end else { break }

                for neighbor in current.neighbors where !closed.contains(neighbor) {
                    let newG = neighbor.risk + current.g
                    if newG < neighbor.g || !open.contains(neighbor) {
                        neighbor.previous = current
                        neighbor.g = newG
                        neighbor.calcH(for: end)
                        open.insert(neighbor)
                    }
                }
            }

            var current = end
            var path = [end]
            while let next = current.previous, next !== start {
                path.append(next)
                current = next
            }
//            print(path.reversed().map( { $0.debugDescription }).joined(separator: "\n"))
            return path.reduce(0) { $0 + $1.risk }
        case .part2:
            return 0
        }
    }
}

private struct PriorityQueue<T: Comparable> {
    private var queue: [T]

    init(_ items: [T]) {
        self.queue = items.sorted()
    }

    mutating func insert(_ item: T) {
        guard !queue.contains(item) else {
            // re-sort because trying to re-insert an item might mean that item has changed
            queue.sort()
            return
        }

        if let last = queue.last, item >= last {
            queue.append(item)
            return
        }

        for (i, other) in queue.enumerated() {
            if item <= other {
                queue.insert(item, at: i)
                return
            }
        }

        queue.append(item)
    }

    mutating func pop() -> T? {
        guard !queue.isEmpty else { return nil }

        return queue.removeFirst()
    }

    func contains(_ item: T) -> Bool { queue.contains(item) }
}

private class Point: NSObject, Comparable {
    static func < (lhs: Point, rhs: Point) -> Bool {
        lhs.f < rhs.f
    }

    override var debugDescription: String {
        "\(x), \(y): \(risk) | \(f) [g: \(g), h: \(h)]"
    }

    var risk: Int
    var x: Int
    var y: Int
    var neighbors = [Point]()

    var previous: Point?
    var h: Int
    var g: Int
    var f: Int { h + g }

    init(risk: Int, x: Int, y: Int) {
        self.risk = risk
        self.x = x
        self.y = y
        self.g = risk
        self.h = 0
    }

    func calcH(for end: Point) {
        h = distance(from: end)
    }

    private func distance(from other: Point) -> Int {
        abs(x - other.x) + abs(y - other.y)
    }
}
