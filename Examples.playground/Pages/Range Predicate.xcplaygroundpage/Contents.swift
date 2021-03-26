//: [Previous](@previous)

import Foundation
import Peppermint

/*:
 ## `RangePredicate`

 In the following example we use a `RangePredicate` to evaluate if a given age is allowed to drink.
 */

let predicate = RangePredicate(min: 21)

predicate.evaluate(with: 18)
predicate.evaluate(with: 21)
predicate.evaluate(with: 25)

/*:
 In the following example we use a `RangePredicate` to evaluate if a date is within a given interval.
 */

let interval = RangePredicate(
    min: Date(timeIntervalSince1970: 0),
    max: Date(timeIntervalSince1970: 10000)
)

interval.evaluate(with: Date(timeIntervalSince1970: 0))
interval.evaluate(with: Date(timeIntervalSince1970: 1))
interval.evaluate(with: Date(timeIntervalSince1970: 999))
interval.evaluate(with: Date(timeIntervalSince1970: 10000))
interval.evaluate(with: Date(timeIntervalSince1970: 10001))

//: [Next](@next)
