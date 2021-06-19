//: [Previous](@previous)

import Foundation
import Peppermint

enum Failure: Error {
    case notEven
}

/*:
 ## `AnyConstraint`
 
 In the following example we erase the type of a `BlockConstraint` by creating an instance of an `AnyConstraint`.
 */

let constraint = BlockConstraint<Int, Failure> {
    $0 % 2 == 0
} errorBuilder: {
    .notEven
}

let anyConstraint = AnyConstraint(constraint)
anyConstraint.evaluate(with: 3)

/*:
 In the following example we erase the type of a `BlockConstraint` by calling the `.erase()` method.
 */

var erasedConstraint = constraint.erase()
erasedConstraint.evaluate(with: 5)

//: [Next](@next)
