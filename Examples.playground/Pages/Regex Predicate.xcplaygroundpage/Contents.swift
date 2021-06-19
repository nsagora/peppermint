//: [Previous](@previous)

import Foundation
import Peppermint

/*:
 ## `RegexPredicate`
 
 In the following example we use a `RegexPredicate` to evaluate if the user input is a non-empty string, composed only from digits.
 */

let predicate = RegexPredicate(expression: "^\\d+$")
predicate.evaluate(with: "1234567890")
predicate.evaluate(with: "abcdefgh")

//: [Next](@next)
