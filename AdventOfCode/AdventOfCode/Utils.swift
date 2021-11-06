//
//  Utils.swift
//  AdventOfCode
//
//  Created by Ryan Arana on 11/6/21.
//

import Foundation

extension Collection where Element: StringProtocol {
    var chunked: [[Element]] {
        var result = [[Element]]()

        var currentChunk = [Element]()
        for line in self {
            if line.isEmpty {
                result.append(currentChunk)
                currentChunk.removeAll()
            } else {
                currentChunk.append(line)
            }
        }
        if !currentChunk.isEmpty {
            result.append(currentChunk)
        }

        return result
    }
}
