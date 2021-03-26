//: [Previous](@previous)

import Foundation
import Peppermint

/*:
 ## Conditioned Constraint
 
 In the following example we use `BlockPredicate` based `Constraint` to evaluate if a username has at least 5 characters. The constraint is conditioned by a `RegexPredicate` based `Constraints` that requires the username to contain only digits.
 
 If the condition doesn't take place, then the evaluation fails before checking the length.
 */

let text = "1234567890"
let minLength = BlockPredicate<String> { $0.count >= 5 }
let isNumerical = RegexPredicate(expression: "^(0|[1-9][0-9]*)$")

let minConstraint = PredicateConstraint(minLength, error: Form.Username.invalid("Too short."))
let numericConstraint = PredicateConstraint(isNumerical, error: Form.Username.invalid("Not numeric"))
var lengthConstraint = ConditionedConstraint(minConstraint, conditions: [numericConstraint])

let result = lengthConstraint.evaluate(with: text)

switch result {
case .success:
    print("You 🤘! ")
case .failure(let summary):
    print(summary.errors)
}

//: [Next](@next)

