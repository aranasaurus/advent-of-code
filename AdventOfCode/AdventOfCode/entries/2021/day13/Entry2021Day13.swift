//
//  Entry2021Day13.swift
//  AdventOfCode
//
//  Created by Ryan Arana on 12/12/21.
//

import Foundation

class Entry2021Day13: Entry {
    init(_ part: Part) {
        super.init(year: 2021, day: 13, part: part)
    }

    @Sendable override func run() async throws {
        let inputs = try String(contentsOf: try fileURL())
            .split(separator: "\n", omittingEmptySubsequences: false)

        let answer = await run(for: inputs)
        DispatchQueue.main.async {
            self.answer = "\(answer)"
        }
    }

    func run<AnyString: StringProtocol>(for input: [AnyString]) async -> Int {
        let points = input
            .split(separator: "")[0]
            .map(Point.init(_:))

        let folds: [Point] = input
            .split(separator: "")[1]
            .compactMap {
                let command = $0
                    .split(separator: "=")
                    .map(String.init(_:))
                guard let value = Int(command[1]) else { return nil }

                return Point(
                    x: command[0].hasSuffix("x") ? value : Int.min,
                    y: command[0].hasSuffix("y") ? value : Int.min
                )
            }

        let page = Page(points: points)

        switch part {
        case .part1:
            page.fold(at: folds[0])
            return page.points.count
        case .part2:
            return 0
        }
    }
}

private class Page {
    var points: Set<Point>

    init(points: [Point]) {
        self.points = Set(points)
    }

    func fold(at foldPoint: Point) {
        if foldPoint.x == Int.min {
            // horizontal fold at y
            for var point in points where point.y > foldPoint.y {
                points.remove(point)
                point.y = foldPoint.y - (point.y - foldPoint.y)
                points.insert(point)
            }
        } else {
            // vertical fold at x
            for var point in points where point.x > foldPoint.x {
                points.remove(point)
                point.x = foldPoint.x - (point.x - foldPoint.x)
                points.insert(point)
            }
        }
    }
}

private struct Point: Hashable {
    var x: Int
    var y: Int

    init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }

    init<AnyString: StringProtocol>(_ text: AnyString) {
        let numbers = text
            .split(separator: ",")
            .compactMap(Int.init(_:))
        x = numbers[0]
        y = numbers[1]
    }
}
