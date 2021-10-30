//
//  Day1.swift
//  advent-of-code-2020
//
//  Created by Ryan Arana on 10/29/21.
//

import SwiftUI

struct Day1: View, EntryViewable {
    let year = 2020
    let day = 1

    let calculator = Day1Calculator()
    @State private var answer = 0
    
    var body: some View {
        Text("Answer: \(answer)")
            .task {
                answer = await calculator.run()
            }
    }
}

struct Day1Calculator {
    func run() async -> Int {
        guard let url = Bundle.main.url(forResource: "day1-input", withExtension: "txt") else {
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
        
        return numbers.count
    }

    func run(for input: [Int]) async -> Int {
        return 1
    }
}

struct Day1_Previews: PreviewProvider {
    static var previews: some View {
        Day1()
    }
}
