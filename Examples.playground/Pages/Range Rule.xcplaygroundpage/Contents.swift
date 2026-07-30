//: [Previous](@previous)

import Foundation
import Peppermint

/*:
 ## `RangeRule`

 In the following example we use a `RangeRule` to evaluate if a given age is allowed to drink.
 */

let rule = RangeRule(min: 21)

rule.evaluate(with: 18)
rule.evaluate(with: 21)
rule.evaluate(with: 25)

/*:
 In the following example we use a `RangeRule` to evaluate if a date is within a given interval.
 */

let interval = RangeRule(
    min: Date(timeIntervalSince1970: 0),
    max: Date(timeIntervalSince1970: 10000)
)

interval.evaluate(with: Date(timeIntervalSince1970: 0))
interval.evaluate(with: Date(timeIntervalSince1970: 1))
interval.evaluate(with: Date(timeIntervalSince1970: 999))
interval.evaluate(with: Date(timeIntervalSince1970: 10000))
interval.evaluate(with: Date(timeIntervalSince1970: 10001))

//: [Next](@next)
