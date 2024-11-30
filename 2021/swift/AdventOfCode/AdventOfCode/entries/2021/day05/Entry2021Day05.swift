//
//  Entry2021Day05.swift
//  AdventOfCode
//
//  Created by Ryan Arana on 12/5/21.
//

import Foundation

class Entry2021Day05: Entry {
    init(_ part: Part) {
        super.init(year: 2021, day: 5, part: part)
    }

    @Sendable override func run() async throws {
        let inputLines = try String(contentsOf: try fileURL())
            .split(separator: "\n")

        progress.totalUnitCount = Int64(inputLines.count * 2)
        let answer = await run(for: inputLines)
        DispatchQueue.main.async {
            self.answer = "\(answer)"
        }
    }

    func run<AnyString: StringProtocol>(for input: [AnyString]) async -> Int {
        var vectors = [Vector]()

        for line in input {
            guard let vector = Vector(line: line) else { continue }

            vectors.append(vector)
            progress.completedUnitCount += 1
        }

        if part == .part1 {
            vectors = vectors.filter({ $0.isHorizontalOrVertical })
        }

        var overlappingPoints = [Point]()
        for (i, a) in vectors.enumerated() {
            for b in vectors.suffix(from: i+1) {
                overlappingPoints.append(contentsOf: a.overlappingPoints(with: b))
            }
            progress.completedUnitCount += 1
        }
        return Set(overlappingPoints).count
    }
}

extension Entry2021Day05 {
    struct Point: Equatable, Hashable, CustomDebugStringConvertible {
        let x: Int
        let y: Int

        var debugDescription: String {
            "\(x),\(y)"
        }

        init?<AnyString: StringProtocol>(string: AnyString) {
            let coords = string
                .split(separator: ",")
                .compactMap(Int.init(_:))

            guard coords.count == 2 else { return nil }

            x = coords[0]
            y = coords[1]
        }

        init(_ x: Int, _ y: Int) {
            self.x = x
            self.y = y
        }
    }

    struct Vector: Equatable, CustomDebugStringConvertible {
        static func == (lhs: Vector, rhs: Vector) -> Bool {
            return (lhs.start == rhs.start
                    && lhs.end == rhs.end)
            || (lhs.start == rhs.end
                && lhs.end == rhs.start)
        }

        let start: Point
        let end: Point

        let points: Set<Point>

        var debugDescription: String {
            "(\(start))-(\(end))"
        }

        var isHorizontalOrVertical: Bool {
            start.x == end.x || start.y == end.y
        }

        init?<AnyString: StringProtocol>(line: AnyString) {
            let pointInputs = line
                .split(separator: " ")
                .compactMap(Point.init(string:))

            guard pointInputs.count == 2 else { return nil }

            let start = pointInputs[0]
            self.start = start
            let end = pointInputs[1]
            self.end = end

            let xs = [start.x, end.x].sorted()
            let horizontalRange = xs[0] ... xs[1]
            let ys = [start.y, end.y].sorted()
            let verticalRange = ys[0] ... ys[1]

            if horizontalRange.count == 1 {
                points = Set(
                    verticalRange.map { y in Point(start.x, y) }
                )
            } else if verticalRange.count == 1 {
                points = Set(
                    horizontalRange.map { x in Point(x, start.y) }
                )
            } else {
                var points = Set<Point>()
                let xInc = start.x < end.x ? 1 : -1
                let yInc = start.y < end.y ? 1 : -1
                for (x, y) in zip(
                    stride(from: start.x, through: end.x, by: xInc),
                    stride(from: start.y, through: end.y, by: yInc)
                ) {
                    points.insert(Point(x, y))
                }
                self.points = points
            }
        }

        func overlappingPoints(with other: Vector) -> Set<Point> {
            points.intersection(other.points)
        }
    }
}
