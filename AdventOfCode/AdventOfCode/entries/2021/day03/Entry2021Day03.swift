//
//  Entry2021Day03.swift
//  AdventOfCode
//
//  Created by Ryan Arana on 12/3/21.
//

import Foundation

class Entry2021Day03: Entry {
    init(_ part: Part) {
        super.init(year: 2021, day: 3, part: part)
    }

    @Sendable override func run() async throws {
        let inputLines = try String(contentsOf: try fileURL())
            .split(separator: "\n", omittingEmptySubsequences: true)
            .map(String.init(_:))

        progress.totalUnitCount = Int64(inputLines.count)
        let answer = await run(for: inputLines)
        DispatchQueue.main.async {
            self.answer = "\(answer)"
        }
    }

    func run(for input: [String]) async -> Int {
        switch part {
        case .part1:
            var bits = [Int]()
            let half = input.count / 2

            progress.totalUnitCount += 1
            for line in input {
                defer { progress.completedUnitCount += 1 }

                for (i, bit) in line.enumerated() {
                    if bits.count == i {
                        bits.append(0)
                    }

                    guard bits[i] < half, bit == "1" else { continue }
                    bits[i] += 1
                }
            }

            let bitMask = bits.count - 1
            let gamma = bits.enumerated().reduce(0) { (result, item) -> Int in
                let bit = item.element >= half ? 1 : 0
                let offset = bitMask - item.offset

                return result + (bit << offset)
            }

            let epsilon = flip(gamma, bitMask: bitMask)
            progress.completedUnitCount += 1

            return gamma * epsilon
        case .part2:
            progress.totalUnitCount = 2

            let o2Rating = rating(of: .o2, in: input)
            progress.completedUnitCount = 1

            let co2Rating = rating(of: .co2, in: input)
            progress.completedUnitCount = 2

            return o2Rating * co2Rating
        }
    }

    private func flip(_ number: Int, bitMask: Int) -> Int {
        ~number & ((1 << bitMask) - 1)
    }

    private func mostCommonBit(at index: Int, in input: [String]) -> Int {
        let half = input.count / 2
        var ones = 0
        var zeros = 0

        for line in input {
            if line[line.index(line.startIndex, offsetBy: index)] == "1" {
                ones += 1
            } else {
                zeros += 1
            }

            if ones > half || zeros > half {
                break
            }
        }

        return ones == zeros ? 1 : ones > zeros ? 1 : 0
    }

    private func rating(of type: RatingType, in input: [String]) -> Int {
        var bitPosition = 0
        var values = input
        let bitWidth = input.first?.count ?? 0

        while values.count != 1 && bitPosition < bitWidth {
            var bit = mostCommonBit(at: bitPosition, in: values)
            if type == .co2 {
                bit = flip(bit, bitMask: 1)
            }
            
            values = values.filter {
                $0[$0.index($0.startIndex, offsetBy: bitPosition)] == Character("\(bit)")
            }
            bitPosition += 1
        }

        return Int(values[0], radix: 2) ?? 0
    }
}

extension Entry2021Day03 {
    enum RatingType {
        case o2
        case co2
    }
}
