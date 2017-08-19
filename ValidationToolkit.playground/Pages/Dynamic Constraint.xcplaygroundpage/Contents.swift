//: [Previous](@previous)

import Foundation
import ValidationToolkit

/*:
 ## Dynamic Constraint
 
 In the following example we use a `BlockPredicate` based `Constraint` to evaluate if an username has at least 5 characters. The error is dynamically built at evaluation time. 
 */

let text = "1234567890"
let predicate = BlockPredicate<String> { $0.characters.count >= 5 }

let constraint = Constraint(predicate: predicate) { Form.Username.invalid($0)}
let result = constraint.evaluate(with: text)

switch result {
case .valid:
    print("Here, have a 🍩. ")
case .invalid(let error):
    print(error.localizedDescription)
}

//: [Next](@next)
