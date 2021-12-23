//
//  Entry2021Day16.swift
//  AdventOfCode
//
//  Created by Ryan Arana on 12/21/21.
//

import Foundation
import Collections

class Entry2021Day16: Entry {
    init(_ part: Part) {
        super.init(year: 2021, day: 16, part: part)
    }

    @Sendable override func run() async throws {
        let input = try String(contentsOf: try fileURL())

        let answer = run(for: input)
        DispatchQueue.main.async {
            self.answer = "\(answer)"
        }
    }

    func run(for input: String) -> Int {
        switch part {
        case .part1:
            return 0
        case .part2:
            return 0
        }
    }
}

extension Entry2021Day16 {
    struct Packet: Equatable {
        var version: Int
        var type: PacketType

        init(version: Int, type: PacketType) {
            self.version = version
            self.type = type
        }

        init?(_ string: String) {
            let bin = Packet.expandHexToBin(string)
            guard let header = Packet.parseHeader(from: bin) else { return nil }

            self.version = header.version

            let payloadBits = String(bin[bin.index(bin.startIndex, offsetBy: 6)...])
            self.type = PacketType(typeID: header.typeID, payloadBits: payloadBits)
        }

        static func parseHeader(from bin: String) -> (version: Int, typeID: Int)? {
            /*
             The BITS transmission contains a single packet at its outermost layer which itself contains many
             other packets. The hexadecimal representation of this packet might encode a few extra 0 bits at
             the end; these are not part of the transmission and should be ignored.

             Every packet begins with a standard header: the first three bits encode the packet version, and
             the next three bits encode the packet type ID. These two values are numbers; all numbers encoded
             in any packet are represented as binary with the most significant bit first. For example, a
             version encoded as the binary sequence 100 represents the number 4.
             */
            let headerStart = bin.startIndex
            let versionEnd = bin.index(headerStart, offsetBy: 3)
            let typeIDEnd = bin.index(versionEnd, offsetBy: 3)
            guard
                let version = Int(bin[headerStart..<versionEnd], radix: 2),
                let typeID = Int(bin[versionEnd..<typeIDEnd], radix: 2)
            else { return nil }

            return (version, typeID)
        }

        static func parseSubPacket(payloadBits: String) -> (packet: Packet, size: Int)? {
            let headerEnd = payloadBits.index(payloadBits.startIndex, offsetBy: 6)
            let remainingBits = String(payloadBits[headerEnd...])

            guard let header = parseHeader(from: String(payloadBits[..<headerEnd])) else { return nil }

            switch header.typeID {
            case 4:
                let payload = PacketType.parseLiteralPayload(from: remainingBits)!
                return (Packet(version: header.version, type: .literal(value: payload.value)), payload.size + 6)
            default:
                // TODO: I'm unsure if the other packet types are needed... gonna wait til I know they are to implement this.
                return nil
            }
        }
    }

    enum PacketType: Equatable {
        case literal(value: Int)
        case lengthOperator(length: Int, payload: String)
        case countOperator(packetCount: Int, payload: [Packet])

        static func parseLiteralPayload(from bits: String) -> (value: Int, size: Int)? {
            var payload = ""
            /*
             Literal value packets encode a single binary number. To do this, the binary number is padded with
             leading zeroes until its length is a multiple of four bits and then it is broken into groups of
             four bits.
             */
            for i in stride(from: 0, to: bits.count - 4, by: 5) {
                let start = bits.index(bits.startIndex, offsetBy: i)
                let groupStart = bits.index(start, offsetBy: 1)
                let end = bits.index(groupStart, offsetBy: 4)
                payload.append(String(bits[groupStart..<end]))

                /*
                 Each group is prefixed by a 1 bit except the last group, which is prefixed by a 0 bit.
                 */
                if bits[start] == "0" {
                    return (Int(payload, radix: 2)!, payload.count)
                }
            }

            return nil
        }

        init(typeID: Int, payloadBits: String) {
            switch typeID {
            case 4:
                /*
                 Packets with type ID 4 represent a literal value.
                 */
                let payload = Entry2021Day16.PacketType.parseLiteralPayload(from: payloadBits)!
                self = .literal(value: payload.value)
            default:
                /*
                 Every other type of packet (any packet with a type ID other than 4) represent an operator that
                 performs some calculation on one or more sub-packets contained within. Right now, the specific
                 operations aren't important; focus on parsing the hierarchy of sub-packets.
                 */

                /*
                 An operator packet contains one or more packets. To indicate which subsequent binary data
                 represents its sub-packets, an operator packet can use one of two modes indicated by the bit
                 immediately after the packet header; this is called the length type ID:
                 */
                let payloadStart = payloadBits.index(payloadBits.startIndex, offsetBy: 1)
                let payload: String
                switch payloadBits[payloadBits.startIndex] {
                case "0":
                    /*
                     - If the length type ID is 0, then the next 15 bits are a number that represents the total
                     length in bits of the sub-packets contained by this packet.
                     */
                    let lengthEnd = payloadBits.index(payloadStart, offsetBy: 15)
                    let length = Int(payloadBits[payloadStart..<lengthEnd], radix: 2)!
                    let payloadEnd = payloadBits.index(lengthEnd, offsetBy: length)

                    /*
                     Finally, after the length type ID bit and the 15-bit or 11-bit field, the sub-packets appear.
                     */
                    payload = String(payloadBits[lengthEnd..<payloadEnd])
                    self = .lengthOperator(length: length, payload: payload)
                case "1":
                    /*
                     - If the length type ID is 1, then the next 11 bits are a number that represents the number
                     of sub-packets immediately contained by this packet.
                     */
                    let lengthEnd = payloadBits.index(payloadStart, offsetBy: 11)
                    let count = Int(payloadBits[payloadStart..<lengthEnd], radix: 2)!

                    /*
                     Finally, after the length type ID bit and the 15-bit or 11-bit field, the sub-packets appear.
                     */
                    var payload = [Packet]()
                    var packetStart = lengthEnd
                    for _ in 0..<count {
                        let packet = Packet.parseSubPacket(payloadBits: String(payloadBits[packetStart...]))!
                        packetStart = payloadBits.index(packetStart, offsetBy: packet.size + 1)
                        payload.append(packet.packet)
                    }
                    self = .countOperator(packetCount: count, payload: payload)
                default:
                    fatalError("Invalid payload: \(payloadBits)")
                }
            }
        }
    }
}

extension Entry2021Day16.Packet {
    static func expandHexToBin(_ hex: String) -> String {
        hex.map {
            switch $0 {
            case "0":
                return "0000"
            case "1":
                return "0001"
            case "2":
                return "0010"
            case "3":
                return "0011"
            case "4":
                return "0100"
            case "5":
                return "0101"
            case "6":
                return "0110"
            case "7":
                return "0111"
            case "8":
                return "1000"
            case "9":
                return "1001"
            case "A":
                return "1010"
            case "B":
                return "1011"
            case "C":
                return "1100"
            case "D":
                return "1101"
            case "E":
                return "1110"
            case "F":
                return "1111"
            default:
                return ""
            }
        }.joined()
    }
}
