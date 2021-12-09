//
//  Entry2021Day09.swift
//  AdventOfCode
//
//  Created by Ryan Arana on 12/9/21.
//

import Foundation

class Entry2021Day09: Entry {
    init(_ part: Part) {
        super.init(year: 2021, day: 9, part: part)
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
        progress.totalUnitCount = Int64(input.count)
        defer { progress.completedUnitCount = progress.totalUnitCount }

        var heights = [[Int]]()
        for line in input {
            let row = line
                .unicodeScalars
                .map(String.init(_:))
                .compactMap(Int.init(_:))
            heights.append(row)
        }

        let heightMap = HeightMap(heights: heights)

        switch part {
        case .part1:
            return heightMap.points
                .flatMap({ $0 })
                .filter { $0.isLowPoint }
                .reduce(0) { result, point in
                    result + point.height + 1
                }
        case .part2:
            return heightMap.basinSizes
                .sorted(by: >)
                .prefix(3)
                .reduce(1, *)
        }
    }
}

private class Point {
    var height: Int
    var above: Point?
    var below: Point?
    var left: Point?
    var right: Point?

    var isLowPoint: Bool {
        let adjacentHeights = Set([
            left?.height,
            right?.height,
            above?.height,
            below?.height
        ].compactMap({ $0 }))

        return !adjacentHeights.isEmpty && adjacentHeights.allSatisfy({ $0 > height })
    }

    weak private(set) var basin: Point?

    init(height: Int) {
        self.height = height
    }

    func setBasin(_ basin: Point) -> Int {
        guard self.basin == nil, height != 9 else { return 0 }

        self.basin = basin

        return 1 + (above?.setBasin(basin) ?? 0)
        + (below?.setBasin(basin) ?? 0)
        + (left?.setBasin(basin) ?? 0)
        + (right?.setBasin(basin) ?? 0)
    }
}

private class HeightMap {
    var points = [[Point]]()

    lazy var basinSizes: [Int] = {
        points
            .flatMap { $0 }
            .filter { $0.isLowPoint }
            .map { $0.setBasin($0) }
    }()

    init(heights: [[Int]]) {
        for (y, rowHeights) in heights.enumerated() {
            var row = [Point]()
            for (x, height) in rowHeights.enumerated() {
                let point = Point(height: height)

                if y > 0 {
                    point.above = points[y-1][x]
                }

                if x > 0 {
                    point.left = row[x-1]
                }

                point.above?.below = point
                point.left?.right = point

                row.append(point)
            }
            points.append(row)
        }
    }
}
