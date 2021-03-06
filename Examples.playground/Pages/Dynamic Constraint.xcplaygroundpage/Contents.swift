//: [Previous](@previous)

import Foundation
import ValidationToolkit

/*:
 ## Dynamic Constraint
 
 In the following example we use a `BlockPredicate` based `Constraint` to evaluate if an username has at least 5 characters. The error is dynamically built at evaluation time. 
 */

let text = "1234567890"
let constraint = PredicateConstraint {
    $0.count >= 5
} errorBuilder: {
    Form.Username.invalid($0)
}

let result = constraint.evaluate(with: text)

switch result {
case .success:
    print("Here, have a 🍩. ")
case .failure(let summary):
    print(summary.errors)
}

//: [Next](@next)
