//: [Previous](@previous)

import Foundation
import ValidationToolkit

/*:
 ## `RangePredicate`

 In the following example we use a `RangePredicate` to evaluate if a given age is allowed to drink.
 */

let predicate = RangePredicate(min: 21)

predicate.evaluate(with: 18)
predicate.evaluate(with: 21)
predicate.evaluate(with: 25)

//: [Next](@next)
