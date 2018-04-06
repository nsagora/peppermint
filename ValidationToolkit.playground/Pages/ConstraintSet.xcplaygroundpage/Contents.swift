//: [Previous](@previous)

import Foundation
import ValidationToolkit

/*:
 ## ConstraintSet
 
 In the following example we use a `ConstraintSet` to evaluate the strength of the user password.
 */

let lowerCasePredicate = RegexPredicate(expression: "^(?=.*[a-z]).*$")
let upperCasePredicate = RegexPredicate(expression: "^(?=.*[A-Z]).*$")
let digitsPredicate = RegexPredicate(expression: "^(?=.*[0-9]).*$")
let specialChars = RegexPredicate(expression: "^(?=.*[!@#\\$%\\^&\\*]).*$")
let minLenght = RegexPredicate(expression: "^.{8,}$")

var passwordConstraints = ConstraintSet<String>()
passwordConstraints.add(predicate: lowerCasePredicate, error: Form.Password.missingLowercase)
passwordConstraints.add(predicate: upperCasePredicate, error: Form.Password.missingUpercase)
passwordConstraints.add(predicate: digitsPredicate, error: Form.Password.missingDigits)
passwordConstraints.add(predicate: specialChars, error: Form.Password.missingSpecialChars)
passwordConstraints.add(predicate: minLenght, error: Form.Password.minLenght(8))

let password = "3nGuard!"
let result = passwordConstraints.evaluateAll(input: password)

switch result {
case .valid:
    print("Wow, that's a 💪 password!")
case .invalid(let summary):
    print(summary.errors.map({$0.localizedDescription}))
}
