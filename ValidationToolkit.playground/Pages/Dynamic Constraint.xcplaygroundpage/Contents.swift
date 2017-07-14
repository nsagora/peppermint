//: [Simpe Constraint](@previous)

import Foundation
import ValidationToolkit

/*:
 ## Dynamic Constraint
 
 Use a `RegexPredicate` base `Constraint` to evaluate if the user input is a non-empty string composed only from digits.
 */

let text = "1234567890"
let predicate = RegexPredicate(expression: "^\\d+$")

let constraint = Constraint(predicate: predicate) { FormError.invalid($0)}
let result = constraint.evaluate(with: text)

switch result {
case .valid:
    print("Well done! Here, have a 🍩. ")
case .invalid(let error):
    print(error.localizedDescription)
}

//: [Next](@next)
