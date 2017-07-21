//: [Previous](@previous)

import Foundation
import ValidationToolkit

/*:
 ## `RegexPredicate`
 
 Use a `RegexPredicate` to evaluate if the user input is a non-empty string composed only from digits.
 */

let input = "1234567890"
let predicate = RegexPredicate(expression: "^\\d+$")
let isValid = predicate.evaluate(with: input)

if isValid {
    print("👍 job!")
}
else {
    print("Expected only digits.")
}

//: [Next](@next)
