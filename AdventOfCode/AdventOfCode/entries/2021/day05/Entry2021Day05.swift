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

        progress.totalUnitCount = Int64(inputLines.count)
        let answer = await run(for: inputLines)
        DispatchQueue.main.async {
            self.answer = "\(answer)"
        }
    }

    func run<AnyString: StringProtocol>(for input: [AnyString]) async -> Int {
        switch part {
        case .part1:
            defer { progress.completedUnitCount = progress.totalUnitCount }

            let vectors = Set(
                input
                    .compactMap(Vector.init(line:))
                    .filter { $0.isHorizontalOrVertical }
            )

            var alreadyCalculated = Set<Vector>()
            var overlappingPoints = Set<Point>()
            for a in vectors {
                alreadyCalculated.insert(a)
                for b in vectors.subtracting(alreadyCalculated) {
                    for point in a.overlappingPoints(with: b) {
                        overlappingPoints.insert(point)
                    }
                }
            }

            return overlappingPoints.count
        case .part2:
            return 0
        }
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

    struct Vector: Hashable, Equatable, CustomDebugStringConvertible {
        static func == (lhs: Vector, rhs: Vector) -> Bool {
            return (lhs.start == rhs.start
                    && lhs.end == rhs.end)
            || (lhs.start == rhs.end
                && lhs.end == rhs.start)
        }

        let start: Point
        let end: Point

        var debugDescription: String {
            "(\(start))-(\(end))"
        }

        var verticalRange: ClosedRange<Int> {
            let ys = [start.y, end.y].sorted()
            return ys[0] ... ys[1]
        }

        var horizontalRange: ClosedRange<Int> {
            let xs = [start.x, end.x].sorted()
            return xs[0] ... xs[1]
        }

        var isHorizontalOrVertical: Bool {
            start.x == end.x || start.y == end.y
        }

        init?<AnyString: StringProtocol>(line: AnyString) {
            let points = line
                .split(separator: " ")
                .compactMap(Point.init(string:))

            guard points.count == 2 else { return nil }

            start = points[0]
            end = points[1]
        }

        func overlappingPoints(with other: Vector) -> Set<Point> {
            guard verticalRange.overlaps(other.verticalRange), horizontalRange.overlaps(other.horizontalRange)
            else { return [] }

            return Set(
                horizontalRange
                    .filter(other.horizontalRange.contains(_:))
                    .map { x in
                        verticalRange.filter(other.verticalRange.contains(_:))
                            .map { y in
                                Point(x, y)
                            }
                    }
                    .flatMap({ $0 })
            )
        }
    }
}
