import Foundation

public extension SequenceType where Generator.Element: Equatable {
    func countElement(element: Generator.Element) -> Int {
        var total = 0
        for item in self {
            if item == element {
                total += 1
            }
        }
        return total
    }
}
