//: [Previous](@previous)

import Foundation
import Peppermint

/*:
 ## `OptionalConstraint`
 
 In the following example we use `OptionalConstraint` based `Constraint` to evaluate if an optional string contains an email and that email is syntactically valid.
 
 If the optional is `nil`, then the summary will contain the required error.
 */


let email: String? = nil
let constraint = OptionalConstraint<String, Form.Email>(required: .missing) {
    PredicateConstraint(.email) {
        .invalid($0)
    }
}

let result = constraint.evaluate(with: email)

switch result {
case .success:
    print("You got 📬!")
case .failure(let summary):
    print(summary.errors.map({$0.localizedDescription}))
}

//: [Next](@next)
