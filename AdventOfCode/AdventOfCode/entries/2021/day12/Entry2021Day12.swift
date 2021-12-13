//
//  Entry2021Day12.swift
//  AdventOfCode
//
//  Created by Ryan Arana on 12/11/21.
//

import Foundation

class Entry2021Day12: Entry {
    init(_ part: Part) {
        super.init(year: 2021, day: 12, part: part)
    }

    @Sendable override func run() async throws {
        let inputs = try String(contentsOf: try fileURL())
            .split(separator: "\n")

        let answer = await run(for: inputs)
        DispatchQueue.main.async {
            self.answer = "\(answer)"
        }
    }

    func run<AnyString: StringProtocol>(for input: [AnyString]) async -> Int {
        let map = CaveMap(edges: input.map(String.init(_:)))
        switch part {
        case .part1:
            return map.paths.count
        case .part2:
            return 0
        }
    }
}

/*
 --------------
 start-A
 start-b
 A-c
 A-b
 b-d
 A-end
 b-end
 --------------
     start
     /   \
 c--A-----b--d
     \   /
      end
 --------------
 */

private class CaveMap {
    var map = [String: Set<String>]()
    var paths = [[String]]()

    init(edges: [String]) {
        for edge in edges {
            let nodes = edge
                .split(separator: "-")
                .map(String.init(_:))
            if nodes[1] != "start" {
                map[nodes[0], default: []].insert(nodes[1])
            }
            if nodes[0] != "start" {
                map[nodes[1], default: []].insert(nodes[0])
            }
        }

        for cave in map["start", default: []] {
            paths.append(contentsOf: pathsToEnd(from: cave, priorPath: ["start", cave]))
        }
    }

    func pathsToEnd(from startingCave: String, priorPath: [String]) -> [[String]] {
        var endPaths = [[String]]()
        for adjacent in map[startingCave, default: []] {
            var path = priorPath
            path.append(adjacent)

            if adjacent == "end" {
                endPaths.append(path)
                continue
            }

            guard adjacent.allSatisfy({ $0.isUppercase }) || !priorPath.contains(adjacent) else { continue }

            endPaths.append(contentsOf: pathsToEnd(from: adjacent, priorPath: path))
        }
        return endPaths
    }
}
