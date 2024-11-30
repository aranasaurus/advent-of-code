/*:

## Part One

 Santa is trying to deliver presents in a large apartment building, but he can't find the right floor - the directions he got are a little confusing. He starts on the ground floor (floor 0) and then follows the instructions one character at a time.

An opening parenthesis, `(`, means he should go up one floor, and a closing parenthesis, `)`, means he should go down one floor.

The apartment building is very tall, and the basement is very deep; he will never find the top or bottom floors.

For example:

 * `(())` and `()()` both result in floor 0.
 * `(((` and `(()(()(` both result in floor 3.
 * `))(((((` also results in floor 3.
 * `())` and `))(` both result in floor -1 (the first basement level).
 * `)))` and `)())())` both result in floor -3.

To what floor do the instructions take Santa?
*/

typealias Floor = Int
extension Character {
    func floorValue() -> Floor {
        switch self {
        case "(":
            return 1
        case ")":
            return -1
        default:
            return 0
        }
    }
}

let answer: Floor = instructions.characters.reduce(0) { (currentFloor: Floor, c: Character) in currentFloor + c.floorValue() }
answer

/*:

## Part Two

Now, given the same instructions, find the position of the first character that causes him to enter the basement (floor -1). The first character in the instructions has position 1, the second character has position 2, and so on.

For example:

 * `)` causes him to enter the basement at character position 1.
 * `()())` causes him to enter the basement at character position 5.

What is the position of the character that causes Santa to first enter the basement?
*/

var currentFloor = 0
var position = 0
for c in instructions.characters {
    position += 1
    currentFloor += c.floorValue()
    if currentFloor < 0 { break }
}

let answer2 = position
