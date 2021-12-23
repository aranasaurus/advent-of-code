//
//  Entry2021Day16Tests.swift
//  AdventOfCodeTests
//
//  Created by Ryan Arana on 12/21/21.
//

import XCTest

@testable import AdventOfCode

private typealias Entry = Entry2021Day16
private typealias Packet = Entry.Packet

class Entry2021Day16Tests: XCTestCase {
    func testSampleData() async {
        let entry = Entry(.part1)

        XCTAssertEqual(entry.run(for: "8A004A801A8002F478"), 16)
        XCTAssertEqual(entry.run(for: "620080001611562C8802118E34"), 12)
        XCTAssertEqual(entry.run(for: "C0015000016115A2E0802F182340"), 23)
        XCTAssertEqual(entry.run(for: "A0016C880162017C3686B18A3D4780"), 31)

        entry.part = .part2
        XCTAssertEqual(entry.run(for: "C200B40A82"), 3)
        XCTAssertEqual(entry.run(for: "04005AC33890"), 54)
        XCTAssertEqual(entry.run(for: "880086C3E88112"), 7)
        XCTAssertEqual(entry.run(for: "CE00C43D881120"), 9)
        XCTAssertEqual(entry.run(for: "D8005AC2A8F0"), 1)
        XCTAssertEqual(entry.run(for: "F600BC2D8F"), 0)
        XCTAssertEqual(entry.run(for: "9C0141080250320F1802104A08"), 1)
    }

    func testInput() async throws {
        let part1 = Entry(.part1)
        try await validateInput(part1, expected: "847")

        let part2 = Entry(.part2)
        try await validateInput(part2, expected: "333794664059")
    }

    func testPacketParsing() {
        XCTAssertEqual(
            Packet("D2FE28"),
            Packet(version: 6, type: .literal(value: 2021))
        )

        XCTAssertEqual(
            Packet("38006F45291200"),
            Packet(
                version: 1,
                type: .lessThan(
                    lhs: Packet(version: 6, type: .literal(value: 10)),
                    rhs: Packet(version: 2, type: .literal(value: 20))
                )
            )
        )

        XCTAssertEqual(
            Packet("EE00D40C823060"),
            Packet(
                version: 7,
                type: .max(
                    packets: [
                        Packet(version: 2, type: .literal(value: 1)),
                        Packet(version: 4, type: .literal(value: 2)),
                        Packet(version: 1, type: .literal(value: 3))
                    ]
                )
            )
        )
    }

    func testHexToBin() {
        XCTAssertEqual(Entry.expandHexToBin("D2FE28"), "110100101111111000101000")
        XCTAssertEqual(Entry.expandHexToBin("38006F45291200"), "00111000000000000110111101000101001010010001001000000000")
        XCTAssertEqual(Entry.expandHexToBin("EE00D40C823060"), "11101110000000001101010000001100100000100011000001100000")
    }
}
