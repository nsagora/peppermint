//: [Previous](@previous)

import Foundation
import Peppermint

/*:
 ## Other usage examples
 
 In the following example we create a simple password strength function.
 */

enum Strength: Int {
    case veryWeak = 1
    case weak
    case normal
    case strong
    case veryStrong
}

func getStrength(password: String) -> Strength {
    
    let options = [
        CharacterSetRule(.uppercaseLetters, mode: .inclusive).erase(),
        CharacterSetRule(.lowercaseLetters, mode: .inclusive).erase(),
        CharacterSetRule(.decimalDigits, mode: .inclusive).erase(),
        CharacterSetRule(.specialChars, mode: .inclusive).erase(),
        LengthRule(min: 8).erase()
    ]
    
    .map { $0.evaluate(with: password) }
    .filter { $0 }
    .count

    return Strength(rawValue: options) ?? .weak
}

getStrength(password: "h3llO") // returns .normal

//: [Next](@next)
