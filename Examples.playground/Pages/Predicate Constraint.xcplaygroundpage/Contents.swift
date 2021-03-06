//: [Previous](@previous)

import Foundation
import ValidationToolkit

/*:
 ## Predicate Constraint
 
 In the following example we use a `BlockPredicate` based `Constraint` to evaluate if an username has at least 5 characters.
 */

let username = "username"
let predicate = BlockPredicate<String> { $0.count >= 5 }

let constraint = PredicateConstraint(predicate, error: Form.Username.missing)
let result = constraint.evaluate(with: username)

switch result {
case .success:
    print("Nice 🎬!")
case .failure(let summary):
    print(summary.errors)
}

//: [Next](@next)
