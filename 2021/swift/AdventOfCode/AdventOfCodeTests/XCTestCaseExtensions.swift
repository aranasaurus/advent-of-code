//
//  XCTestCaseExtensions.swift
//  AdventOfCodeTests
//
//  Created by Ryan Arana on 11/2/21.
//

import XCTest

@testable import AdventOfCode

extension XCTestCase {
    func validateInput(_ entry: Entry, expected: String) async throws {
        let answerExpectation = expectation(description: "Answer should be published.")
        let cancellable = entry.$answer
            .dropFirst()
            .sink { answer in
                XCTAssertEqual(answer, expected)
                answerExpectation.fulfill()
            }

        try await entry.run()

        await waitForExpectations(timeout: 1)
        cancellable.cancel()
    }
}
