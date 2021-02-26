//: [Previous](@previous)

import Foundation
import ValidationToolkit

/*:
 ## TypeConstraint
 
 In the following example we use a `TypeConstraint` to evaluate a data strucrure used in a registraton form.
 */

struct RegistrationData {
    
    enum Error: Swift.Error {
        case username
        case password(String)
        case email
        case underAge
    }
    
    var username: String
    var password: String
    var email: String
    var age: Int
}

let usernameConstraint = PredicateConstraint(
    predicate: BlockPredicate<String> { $0.count >= 5 },
    error: RegistrationData.Error.username
)

var passwordConstraint = CompoundContraint(allOf:
    PredicateConstraint(
        predicate: RegexPredicate(expression: "^(?=.*[a-z]).*$"),
        error: RegistrationData.Error.password("Missing lowercase")
    ),
    PredicateConstraint(
        predicate: RegexPredicate(expression: "^(?=.*[A-Z]).*$"),
        error: RegistrationData.Error.password("Missing uppercase")
    ),
    PredicateConstraint(
        predicate: RegexPredicate(expression: "^(?=.*[0-9]).*$"),
        error: RegistrationData.Error.password("Missing digits")
    ),
    PredicateConstraint(
        predicate: RegexPredicate(expression: "^(?=.*[!@#\\$%\\^&\\*]).*$"),
        error: RegistrationData.Error.password("Missing special characters")
    ),
    PredicateConstraint(
        predicate: RegexPredicate(expression: "^.{8,}$"),
        error: RegistrationData.Error.password("Minimum 8 characters required")
    )
)

var emailConstraint = PredicateConstraint(predicate: EmailPredicate(), error: RegistrationData.Error.email)
var ageConstraint = PredicateConstraint(predicate: RangePredicate(min: 14), error: RegistrationData.Error.underAge)

var loginConstraint = TypeConstraint<RegistrationData, RegistrationData.Error>()
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
        print($0)
    }
}

//: [Next](@next)
