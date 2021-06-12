//: [Previous](@previous)

import Foundation
import Peppermint

/*:
 ## Predicate Constraint
 
 In the following example we use a `EmailPredicate` based `Constraint` to evaluate if a given input is a valid email.
 */

let predicate = EmailPredicate()

let constraint = PredicateConstraint(predicate) { Form.Email.invalid($0) }
let result = constraint.evaluate(with: "@nsagora.com")

switch result {
case .success:
    print("Nice 🎬!")
case .failure(let summary):
    print(summary.errors)
}

//: [Next](@next)
