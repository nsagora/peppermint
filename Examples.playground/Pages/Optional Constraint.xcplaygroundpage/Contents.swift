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
    PredicateConstraint(EmailPredicate()) {
        .invalid($0)
    }
}

let result = constraint.evaluate(with: email)

//: [Next](@next)
