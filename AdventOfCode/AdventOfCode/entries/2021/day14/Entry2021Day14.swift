//
//  Entry2021Day14.swift
//  AdventOfCode
//
//  Created by Ryan Arana on 12/13/21.
//

import Foundation

class Entry2021Day14: Entry {
    init(_ part: Part) {
        super.init(year: 2021, day: 14, part: part)
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
        let template = input[0].map { $0 }
        let rules = input
            .suffix(from: 1)
            .filter { !$0.isEmpty }
        
        var insertionMap = [[Character]: Character]()
        for rule in rules {
            let components = rule.split(separator: " ")
            let key = components[0].map { $0 }
            let value = components[2].first!
            insertionMap[key] = value
        }
        
        switch part {
        case .part1:
            return calculate(steps: 10, template: template, insertionMap: insertionMap)
        case .part2:
            return calculate(steps: 40, template: template, insertionMap: insertionMap)
        }
    }
    
    func calculate(steps: Int, template: [Character], insertionMap: [[Character]: Character]) -> Int {
        var pairCounts = [[Character]: Int]()
        var counts = [Character: Int]()
        for character in template {
            counts[character, default: 0] += 1
        }
        
        template
            .prefix(upTo: template.endIndex - 1)
            .indices
            .map { i in
                [template[i], template[i+1]]
            }
            .forEach { pair in
                pairCounts[pair, default: 0] += 1
            }
        
        var stepPairCounts = [[Character]: Int]()
        for _ in 1...steps {
            for pair in pairCounts {
                guard let valueToInsert = insertionMap[pair.key] else {
                    stepPairCounts[pair.key] = pair.value
                    continue
                }
                
                let pair1 = [pair.key[0], valueToInsert]
                let pair2 = [valueToInsert, pair.key[1]]
                
                counts[valueToInsert, default: 0] += pair.value
                stepPairCounts[pair1, default: 0] += pair.value
                stepPairCounts[pair2, default: 0] += pair.value
            }
            
            pairCounts = stepPairCounts
            stepPairCounts.removeAll()
        }
        
        let sortedCounts = counts.sorted(by: { $0.value < $1.value })
        let min = sortedCounts.first?.value ?? 0
        let max = sortedCounts.last?.value ?? 0
        return max - min
    }
}
