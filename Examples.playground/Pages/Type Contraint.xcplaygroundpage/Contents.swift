//: [Previous](@previous)

import Foundation
import Peppermint

/*:
 ## `TypeConstraint`
 
 In the following example we use a `TypeConstraint` to evaluate a data structure used in a registration form.
 */

struct RegistrationData {
    
    enum Error: Swift.Error {
        case username
        case password(Password)
        case email
        case underAge
        case website
    }
    
    enum Password {
        case missingUppercase
        case missingLowercase
        case missingDigits
        case missingSpecialChars
        case tooShort
        case confirmationMismatch
    }
    
    var username: String
    var password: String
    var passwordConfirmation: String
    var email: String
    var age: Int
    var website: String?
}

let constraint = TypeConstraint<RegistrationData, RegistrationData.Error> {
    KeyPathConstraint(\.username) {
        BlockConstraint {
            $0.count >= 5
        } errorBuilder: {
            .username
        }
    }
    KeyPathConstraint(\.password) {
        GroupConstraint(.all) {
            RuleConstraint {
                .characterSet(.lowercaseLetters, mode: .inclusive)
            } errorBuilder: {
                .password(.missingLowercase)
            }
            RuleConstraint {
                .characterSet(.uppercaseLetters, mode: .inclusive)
            } errorBuilder: {
                .password(.missingUppercase)
            }
            RuleConstraint {
                .characterSet(.decimalDigits, mode: .inclusive)
            } errorBuilder: {
                .password(.missingDigits)
            }
            RuleConstraint {
                .characterSet(.specialChars, mode: .inclusive)
            } errorBuilder: {
                .password(.missingSpecialChars)
            }
            RuleConstraint {
                .length(min: 8)
            } errorBuilder: {
                .password(.tooShort)
            }
        }
    }
    BlockConstraint {
        $0.password == $0.passwordConfirmation
    } errorBuilder: {
        .password(.confirmationMismatch)
    }
    KeyPathConstraint(\.email) {
        RuleConstraint(.email, error: .email)
    }
    KeyPathConstraint(\.age) {
        RuleConstraint(.range(min: 14), error: .underAge)
    }
    KeyPathConstraint(\.website) {
        RuleConstraint(.url, error: .website)
            .optional()
    }
}

let user = RegistrationData(
    username: "nsagora",
    password: "p@ssWrd",
    passwordConfirmation: "pssW0rd",
    email: "hello@nsagora.com",
    age: 21,
    website: "http://www.url.com"
)

let result = constraint.evaluate(with: user)

switch result {
case .success:
    print("Account successfully created 🥳")
case .failure(let summary):
    summary.errors.forEach {
        print($0)
    }
}

//: [Next](@next)
