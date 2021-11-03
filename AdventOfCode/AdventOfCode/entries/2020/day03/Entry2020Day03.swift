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
        var position = Point(col: 0, row: 0)
        var count = 0

        while position.row < map.height {
            count += map[position] ? 1 : 0
            position.row += 1
            position.col += 3
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
