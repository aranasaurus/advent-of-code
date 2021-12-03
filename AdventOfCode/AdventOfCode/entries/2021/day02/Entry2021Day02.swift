//
//  Entry2021Day02.swift
//  AdventOfCode
//
//  Created by Ryan Arana on 12/2/21.
//

import Foundation

class Entry2021Day02: Entry {
    init(_ part: Part) {
        super.init(year: 2021, day: 2, part: part)
    }

    @Sendable override func run() async throws {
        let inputLines = try String(contentsOf: try fileURL())
            .split(separator: "\n", omittingEmptySubsequences: false)
            .map(String.init(_:))

        progress.totalUnitCount = Int64(inputLines.count)
        let answer = await run(for: inputLines)
        DispatchQueue.main.async {
            self.answer = "\(answer)"
        }
    }

    func run(for input: [String]) async -> Int {
        var horizontal = 0
        var depth = 0

        switch part {
        case .part1:
            for line in input {
                defer { progress.completedUnitCount += 1 }

                guard let command = Command(rawValue: line) else { continue }

                horizontal += command.horizontalMovement
                depth += command.verticalMovement
            }
        case .part2:
            var aim = 0
            for line in input {
                defer { progress.completedUnitCount += 1 }

                guard let command = Command(rawValue: line) else { continue }

                horizontal += command.horizontalMovement
                aim += command.verticalMovement
                depth += aim * command.horizontalMovement
            }
        }

        return horizontal * depth
    }
}

extension Entry2021Day02 {
    enum Command: RawRepresentable {
        case forward(Int)
        case down(Int)
        case up(Int)

        var rawValue: String {
            switch self {
            case .forward(let amount):
                return "forward \(amount)"
            case .down(let amount):
                return "down \(amount)"
            case .up(let amount):
                return "up \(amount)"
            }
        }

        var horizontalMovement: Int {
            switch self {
            case .forward(let amount):
                return amount
            case .down, .up:
                return 0
            }
        }

        var verticalMovement: Int {
            switch self {
            case .forward:
                return 0
            case .up(let amount):
                return -amount
            case .down(let amount):
                return amount
            }
        }

        init?(rawValue: String) {
            let parts = rawValue.split(separator: " ")

            guard parts.count == 2, let amount = Int(parts[1]) else { return nil }

            switch parts[0] {
            case "forward":
                self = .forward(amount)
            case "down":
                self = .down(amount)
            case "up":
                self = .up(amount)
            default:
                return nil
            }
        }
    }
}
