//: [Previous](@previous)

import Foundation
import ValidationToolkit

/*:
 ## TypeConstraint
 
 In the following example we use a `TypeConstraint` to evaluate a data strucrure used in a registraton form.
 */

struct RegistrationData {
    var username: String
    var password: String
    var email: String
    var age: Int
}

let usernameConstraint = PredicateConstraint(predicate: BlockPredicate<String> { $0.count >= 5 } ) { Form.Username.invalid($0) }

let lowerCasePredicate = RegexPredicate(expression: "^(?=.*[a-z]).*$")
let upperCasePredicate = RegexPredicate(expression: "^(?=.*[A-Z]).*$")
let digitsPredicate = RegexPredicate(expression: "^(?=.*[0-9]).*$")
let specialChars = RegexPredicate(expression: "^(?=.*[!@#\\$%\\^&\\*]).*$")
let minLenght = RegexPredicate(expression: "^.{8,}$")

var passwordConstraint = CompoundContraint<String>(allOf:
    PredicateConstraint(predicate: lowerCasePredicate, error: Form.Password.missingLowercase),
    PredicateConstraint(predicate: upperCasePredicate, error: Form.Password.missingUpercase),
    PredicateConstraint(predicate: digitsPredicate, error: Form.Password.missingDigits),
    PredicateConstraint(predicate: specialChars, error: Form.Password.missingSpecialChars),
    PredicateConstraint(predicate: minLenght, error: Form.Password.minLenght(8))
)

var emailConstraint = PredicateConstraint(predicate: EmailPredicate()) { Form.Email.invalid($0) }
var ageConstraint = PredicateConstraint(predicate: BlockPredicate<Int> { $0 > 14}, error: Form.Age.underage )

var loginConstraint = TypeConstraint<RegistrationData>()
loginConstraint.set(usernameConstraint, for: \.username)
loginConstraint.set(passwordConstraint, for: \.password)
loginConstraint.set(emailConstraint, for: \.email)
loginConstraint.set(ageConstraint, for: \.age)

let user = RegistrationData(username: "me", password: "secure", email: "@example.com", age: 12)

let result = loginConstraint.evaluate(with: user)

switch result {
case .success:
    print("Account successfully created 🥳")
case .failure(let summary):
    summary.errors.forEach {
        print($0.localizedDescription)
    }
}

//: [Next](@next)
