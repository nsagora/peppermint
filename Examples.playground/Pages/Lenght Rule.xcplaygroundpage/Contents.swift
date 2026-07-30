//: [Previous](@previous)

import Foundation
import Peppermint

/*:
 ## `LengthRule`

 In the following example we use a `LengthRule` to evaluate if a given password has the appropriate length.
 */

let rule = LengthRule<String>(min: 8, max: 64)
rule.evaluate(with: "p@ssW0rd")
rule.evaluate(with: "p@ss")

//: [Next](@next)
