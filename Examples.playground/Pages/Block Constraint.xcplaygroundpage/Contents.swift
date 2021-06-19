//: [Previous](@previous)

import Foundation
import Peppermint

/*:
 ## `BlockConstraint`
 
 In the following example we use a `BlockConstraint` to evaluate that a given input has at least 5 characters. The error is dynamically built at evaluation time.
 */

let input = "1234567890"
let constraint = BlockConstraint {
    $0.count >= 5
} errorBuilder: {
    Form.Username.invalid($0)
}

let result = constraint.evaluate(with: input)

switch result {
case .success:
    print("Here, have a 🍩. ")
case .failure(let summary):
    print(summary.errors)
}

//: [Next](@next)
