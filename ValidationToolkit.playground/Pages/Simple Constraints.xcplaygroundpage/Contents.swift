//: [RegexPredicate](@previous)

import Foundation
import ValidationToolkit

/*:
 ## Simple Constraint
 
 Use a `RegexPredicate` based `Constraint` to evaluate if the user input is a non-empty string composed only from digits.
 */

let text = "He!O"
let predicate = RegexPredicate(expression: "^\\d+$")

let constraint = Constraint(predicate: predicate, error:FormError.invalid)
let result = constraint.evaluate(with: text)

switch result {
case .valid:
    print("Nice job ;)")
case .invalid(let error):
    print(error.localizedDescription)
}

//: [Dynamic Constraint](@next)
