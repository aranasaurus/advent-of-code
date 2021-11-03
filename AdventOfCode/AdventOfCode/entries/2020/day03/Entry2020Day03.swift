//
//  Entry2020Day03.swift
//  AdventOfCode
//
//  Created by Ryan Arana on 11/2/21.
//

import Foundation

class Entry2020Day03: Entry {
    init(_ part: Part) {
        super.init(year: 2020, day: 3, part: part)
    }

    @Sendable override func run() async throws {
        let map = try await fileURL().lines.reduce(into: [[Bool]]()) { (result, line) -> Void in
            result.append(parse(line: line))
        }

        guard !map.isEmpty else {
            throw FileError.invalidInputFormat
        }

        let rowWidth = map[0].count
        guard map.allSatisfy({ $0.count == rowWidth }) else {
            throw FileError.invalidInputFormat
        }

        progress.totalUnitCount = Int64(map.count)
        if part == .part2 {
            progress.totalUnitCount *= 5
        }

        let answer = await run(for: map)
        DispatchQueue.main.async {
            self.answer = Entry.formatter.string(from: NSNumber(value: answer))
        }
    }

    func parse(line: String) -> [Bool] {
        line.map {
            String($0) == "#"
        }
    }

    func run(for input: [String]) async -> Int {
        return await run(for: input.map(parse(line:)))
    }

    func run(for input: [[Bool]]) async -> Int {
        let map = Map(map: input)
        var result = 0

        switch part {
        case .part1:
            result = traverse(map, right: 3, down: 1)
        case .part2:
            let a = traverse(map, right: 1, down: 1)
            let b = traverse(map, right: 3, down: 1)
            let c = traverse(map, right: 5, down: 1)
            let d = traverse(map, right: 7, down: 1)
            let e = traverse(map, right: 1, down: 2)

            result = a * b * c * d * e
        }
        return result
    }

    private func traverse(_ map: Map, right: Int, down: Int) -> Int {
        var position = Point(col: 0, row: 0)
        var count = 0

        while position.row < map.height {
            count += map[position] ? 1 : 0
            position.row += down
            position.col += right
            progress.completedUnitCount += 1
        }

        return count
    }
}

private struct Map {
    let map: [[Bool]]

    let width: Int
    let height: Int

    init(map: [[Bool]]) {
        self.map = map
        self.width = map[0].count
        self.height = map.count
    }

    subscript(point: Point) -> Bool {
        get {
            map[point.row][point.col % width]
        }
    }
}

private struct Point {
    var col: Int
    var row: Int
}
