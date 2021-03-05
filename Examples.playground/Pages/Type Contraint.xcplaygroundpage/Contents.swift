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

var loginConstraint = TypeConstraint<RegistrationData, RegistrationData.Error>()

loginConstraint.set(for: \.username) {
    PredicateConstraint {
        $0.count >= 5
    } errorBuilder: {
        .username
    }
}

loginConstraint.set(for: \.password) {
    CompoundContraint.allOf(
        PredicateConstraint {
            RegexPredicate(expression: "^(?=.*[a-z]).*$")
        } errorBuilder: {
            .password("Requires lowercase characters")
        },
        PredicateConstraint{
            RegexPredicate(expression: "^(?=.*[A-Z]).*$")
        } errorBuilder: {
            .password("Requires uppercase characters")
        },
        PredicateConstraint {
            RegexPredicate(expression: "^(?=.*[0-9]).*$")
        } errorBuilder: {
            .password("Requires digits")
        },
        PredicateConstraint {
            RegexPredicate(expression: "^(?=.*[!@#\\$%\\^&\\*]).*$")
        } errorBuilder: {
            .password("Requires special characters")
        },
        PredicateConstraint {
            RegexPredicate(expression: "^.{8,}$")
        }  errorBuilder: {
            .password("Requires minimum 8 characters")
        }
    )
}

loginConstraint.set(for: \.email) {
    PredicateConstraint(EmailPredicate(), error: .email)
}

loginConstraint.set(for: \.age) {
    PredicateConstraint(RangePredicate(min: 14), error: .underAge)
}

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
