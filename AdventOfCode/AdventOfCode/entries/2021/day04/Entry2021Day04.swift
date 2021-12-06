//
//  Entry2021Day04.swift
//  AdventOfCode
//
//  Created by Ryan Arana on 12/4/21.
//

import Foundation

class Entry2021Day04: Entry {
    init(_ part: Part) {
        super.init(year: 2021, day: 4, part: part)
    }

    @Sendable override func run() async throws {
        let inputLines = try String(contentsOf: try fileURL())
            .split(separator: "\n", omittingEmptySubsequences: false)

        progress.totalUnitCount = Int64(inputLines.count)
        let answer = await run(for: inputLines)
        DispatchQueue.main.async {
            self.answer = "\(answer)"
        }
    }

    func run<AnyString: StringProtocol>(for input: [AnyString]) async -> Int {
        switch part {
        case .part1:
            let numbers = input[0].split(separator: ",")
            progress.totalUnitCount += Int64(numbers.count)

            let boardInputs = input.suffix(from: 2)

            var boards = [Board]()
            var iterator = boardInputs.makeIterator()
            var currentBoardLines = [AnyString]()

            while let line = iterator.next() {
                defer { progress.completedUnitCount += 1 }

                guard !line.isEmpty else {
                    let board = Board(lines: currentBoardLines)
                    boards.append(board)

                    currentBoardLines.removeAll()
                    continue
                }

                currentBoardLines.append(line)
            }

            if !currentBoardLines.isEmpty {
                boards.append(Board(lines: currentBoardLines))
            }

            for number in numbers.compactMap( { Int($0) }) {
                defer { progress.completedUnitCount += 1 }

                for board in boards {
                    if board.playNumber(number) {
                        progress.completedUnitCount = progress.totalUnitCount - 1 // the last one will be added by the defer above
                        return number * board.score
                    }
                }
            }

            return 0
        case .part2:
            return 0
        }
    }
}

extension Entry2021Day04 {
    typealias Position = (row: Int, col: Int)

    class Space {
        let value: Int
        var marked = false

        init(value: Int) {
            self.value = value
        }
    }

    struct Board {
        var grid = [[Space]]()

        var score: Int {
            grid
                .flatMap { $0 }
                .filter { !$0.marked }
                .map { $0.value }
                .reduce(0, +)
        }

        private let width: Int

        init<AnyString: StringProtocol>(lines: [AnyString]) {
            var width = 0
            for line in lines {
                let rowSpaces = line
                    .split(separator: " ")
                    .compactMap( { Int($0) })
                    .map(Space.init(value:))

                width = max(width, rowSpaces.count)
                grid.append(rowSpaces)
            }
            self.width = width

            for row in grid {
                if row.count != width {
                    fatalError("All rows are expected to be of the same length (\(width)). Invalid row: \(row)")
                }
            }
        }

        /// Marks board for the given number. Returns true if number makes the board a winner, false otherwise.
        func playNumber(_ number: Int) -> Bool {
            for row in grid {
                if let space = row.first(where: { !$0.marked && $0.value == number }) {
                    space.marked = true

                    if row.allSatisfy({ $0.marked }) {
                        return true
                    } else {
                        for col in 0..<width {
                            if grid.allSatisfy({ $0[col].marked }) {
                                return true
                            }
                        }
                    }
                }
            }

            return false
        }
    }
}
