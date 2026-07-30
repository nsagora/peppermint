//: [Previous](@previous)

import Foundation
import Peppermint

/*:
 ## `RegexRule`
 
 In the following example we use a `RegexRule` to evaluate if the user input is a non-empty string, composed only from digits.
 */

let rule = RegexRule(expression: "^\\d+$")
rule.evaluate(with: "1234567890")
rule.evaluate(with: "abcdefgh")

//: [Next](@next)
