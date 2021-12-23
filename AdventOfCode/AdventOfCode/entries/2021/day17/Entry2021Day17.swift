//
//  Entry2021Day17.swift
//  AdventOfCode
//
//  Created by Ryan Arana on 12/23/21.
//

import Foundation
import Collections

class Entry2021Day17: Entry {
    init(_ part: Part) {
        super.init(year: 2021, day: 17, part: part)
    }

    @Sendable override func run() async throws {
        let input = try String(contentsOf: try fileURL())

        let answer = run(for: input)
        DispatchQueue.main.async {
            self.answer = "\(answer)"
        }
    }

    func run(for input: String) -> Int {
        switch part {
        case .part1:
            return 0
        case .part2:
            return 0
        }
    }
}
