//
//  Entry.swift
//  advent-of-code-2020
//
//  Created by Ryan Arana on 10/31/21.
//

import Foundation

class Entry: ObservableObject {
    enum FileError: Error {
        case invalidInputFileName
    }

    let year: Int
    let day: Int
    let part: Int
    let inputFileName: String
    let inputFileType: String

    @Published var answer: String?
    let progress = Progress(totalUnitCount: 1)

    init(year: Int, day: Int, part: Int, inputFileName: String? = nil, inputFileType: String = "txt") {
        self.year = year
        self.day = day
        self.part = part
        self.inputFileName = inputFileName ?? "day\(day)-input"
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
