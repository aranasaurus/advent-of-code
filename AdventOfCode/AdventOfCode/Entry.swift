//
//  Entry.swift
//  AdventOfCode
//
//  Created by Ryan Arana on 10/31/21.
//

import Foundation

class Entry: ObservableObject {
    enum FileError: Error {
        case invalidInputFileName
        case invalidInputFormat
    }

    enum Part: Int {
        case part1 = 1
        case part2 = 2
    }

    static let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()

    let year: Int
    let day: Int
    var part: Part
    let inputFileName: String
    let inputFileType: String

    @Published var answer: String?
    let progress = Progress(totalUnitCount: 1)

    var webURL: URL {
        URL(string: "https://adventofcode.com/\(year)/day/\(day)#part\(part.rawValue)")!
    }

    init(year: Int, day: Int, part: Part, inputFileName: String? = nil, inputFileType: String = "txt") {
        self.year = year
        self.day = day
        self.part = part
        self.inputFileName = inputFileName ?? "\(year)Day\(day)-input"
        self.inputFileType = inputFileType
    }

    func fileURL() throws -> URL {
        guard let url = Bundle.main.url(forResource: inputFileName, withExtension: inputFileType) else {
            throw FileError.invalidInputFileName
        }
        return url
    }

    @Sendable func run() async throws {
        fatalError("Override in subclass")
    }
}
