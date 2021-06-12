//: [Previous](@previous)

import Foundation
import Peppermint

/*:
 ## `LengthPredicate`

 In the following example we use a `LengthPredicate` to evaluate if a given password has the appropriate length.
 */

let predicate = LengthPredicate<String>(min: 8, max: 64)
predicate.evaluate(with: "p@ssW0rd")
predicate.evaluate(with: "p@ss")

//: [Next](@next)
