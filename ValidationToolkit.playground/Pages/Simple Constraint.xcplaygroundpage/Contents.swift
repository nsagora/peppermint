//: [Previous](@previous)

import Foundation
import ValidationToolkit

/*:
 ## Simple Constraint
 
 In the following example we use a `BlockPredicate` based `Constraint` to evaluate if an username has at least 5 characters.
 */

let username = "He!O"
let predicate = BlockPredicate<String> { $0.characters.count >= 5 }

let constraint = Constraint(predicate: predicate, error:Form.Username.invalid)
let result = constraint.evaluate(with: username)

switch result {
case .valid:
    print("Nice 🎬!")
case .invalid(let error):
    print(error.localizedDescription)
}

//: [Next](@next)
