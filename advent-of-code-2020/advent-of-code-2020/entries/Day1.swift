//
//  Day1.swift
//  advent-of-code-2020
//
//  Created by Ryan Arana on 10/29/21.
//

import SwiftUI

struct Day1: View {
    let calculator = Calculator()
    @State private var answer = 0
    @State var showPopover = false
    
    var body: some View {
        EntryView(
            year: 2020,
            day: 1,
            answerString: { "\(self.answer)" },
            runAction: {
                self.answer = await self.calculator.run()
            },
            content: {
                Text("Part 1 Answer: \(answer)")
            }
        )
    }
}

extension Day1 {
    struct Calculator {
        func run() async -> Int {
            guard let url = Bundle.main.url(forResource: "day1part1-input", withExtension: "txt") else {
                return -1
            }

            let numbers: [Int]
            do {
                numbers = try await url.lines.reduce(into: [Int]()) { (result, line) -> Void in
                    guard let number = Int(line) else { return }
                    result.append(number)
                }
            } catch {
                return -2
            }

            return await run(for: numbers)
        }

        func run(for input: [Int]) async -> Int {
            guard input.count >= 2 else { return 0 }

            for (i, a) in input[0..<input.endIndex - 1].enumerated() {
                for b in input[i..<input.endIndex] {
                    if a + b == 2020 {
                        return a * b
                    }
                }
            }

            return 0
        }
    }
}

struct Day1_Previews: PreviewProvider {
    static var previews: some View {
        Day1()
    }
}
