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
            return map.pathsToEnd(from: "start", priorPath: ["start"]).count
        case .part2:
            return map.pathsToEnd(from: "start", priorPath: ["start"], allowADouble: true).count
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
    let map: [String: Set<String>]

    init(edges: [String]) {
        var map = [String: Set<String>]()
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
        self.map = map
    }

    func pathsToEnd(from startingCave: String, priorPath: [String], allowADouble: Bool = false) -> [[String]] {
        var endPaths = [[String]]()
//        let prefix = priorPath.joined(separator: ",")
//        print("\(prefix): begin")
        for adjacent in map[startingCave, default: []] {
            var path = priorPath
            path.append(adjacent)

            if adjacent == "end" {
                endPaths.append(path)
//                print("\(prefix): found end: \(path.joined(separator: ",")). \(endPaths.count) ends so far")
                continue
            }

            var isDouble = false
            if adjacent.allSatisfy({ $0.isLowercase }) {
                if priorPath.contains(adjacent) {
                    if allowADouble {
//                        print("\(prefix): Allowing double \(adjacent)")
                        isDouble = true
                    } else {
                        // no doubles allowed. this is a dead-end
//                        print("\(prefix): Skipping double \(adjacent)")
                        continue
                    }
                }
            }

            let adjacentEndPaths = pathsToEnd(from: adjacent, priorPath: path, allowADouble: allowADouble && !isDouble)
            endPaths.append(contentsOf: adjacentEndPaths)
//            print("\(prefix): appending \(adjacentEndPaths.count) ends from \(adjacent). \(endPaths.count) ends so far")
        }
//        print("\(prefix): Returning \(endPaths.count) endPaths for \(startingCave).")
        return endPaths
    }
}
