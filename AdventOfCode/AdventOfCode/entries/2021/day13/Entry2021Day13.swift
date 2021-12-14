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
            for fold in folds {
                page.fold(at: fold)
            }
            page.printPage()
            return page.points.count
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

    func printPage() {
        let pointsToDraw = points.sorted(by: {
            guard $0.y == $1.y else { return $0.y < $1.y }
            return $0.x < $1.x
        })

        var x = 0
        var y = 0
        var row = [String]()
        for point in pointsToDraw {
            if point.y != y {
                print(row.joined(separator: ""))
                row.removeAll()
                y += 1
                while y != point.y {
                    print(Array(repeating: " ", count: x+1).joined(separator: ""))
                    y += 1
                }

                x = 0
            }
            if x < point.x {
                row.append(contentsOf: Array(repeating: " ", count: point.x - x))
            }
            row.append("#")
            x = point.x + 1
        }
        print(row.joined(separator: ""))
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
