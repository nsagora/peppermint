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

var constraint = TypeConstraint<RegistrationData, RegistrationData.Error>()

constraint.set(for: \.username) {
    BlockConstraint {
        $0.count >= 5
    } errorBuilder: {
        .username
    }
}

constraint.set(for: \.password) {
    GroupConstraint(.all, constraints:
                        PredicateConstraint {
        .characterSet(.lowercaseLetters, mode: .inclusive)
    } errorBuilder: {
        .password(.missingLowercase)
    },
                    PredicateConstraint{
        .characterSet(.uppercaseLetters, mode: .inclusive)
    } errorBuilder: {
        .password(.missingUppercase)
    },
                    PredicateConstraint {
        .characterSet(.decimalDigits, mode: .inclusive)
    } errorBuilder: {
        .password(.missingDigits)
    },
                    PredicateConstraint {
        .characterSet(CharacterSet(charactersIn: "!?@#$%^&*()|\\/<>,.~`_+-="), mode: .inclusive)
    } errorBuilder: {
        .password(.missingSpecialChars)
    },
                    PredicateConstraint {
        .length(min: 8)
    }  errorBuilder: {
        .password(.tooShort)
    }
    )
}

constraint.set(for: \.email) {
    PredicateConstraint(.email, error: .email)
}

constraint.set(for: \.age) {
    PredicateConstraint(.range(min: 14), error: .underAge)
}

constraint.set(for: \.website) {
    PredicateConstraint(.url, error: .website)
        .optional()
}

let user = RegistrationData(
    username: "nsagora",
    password: "p@ssW0rd",
    passwordConfirmation: "passW0rd",
    email: "hello@nsagora.com",
    age: 21
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

/*:
 In the following example we use the result builder variant of the `TypeConstraint` to evaluate a data structure used in a registration form.
 */

let constraintBuilder = TypeConstraint<RegistrationData, RegistrationData.Error> {
    KeyPathConstraint(\.username) {
        BlockConstraint {
            $0.count >= 5
        } errorBuilder: {
            .username
        }
    }
    KeyPathConstraint(\.password) {
        GroupConstraint(.all) {
            PredicateConstraint {
                .characterSet(.lowercaseLetters, mode: .inclusive)
            } errorBuilder: {
                .password(.missingLowercase)
            }
            PredicateConstraint{
                .characterSet(.uppercaseLetters, mode: .inclusive)
            } errorBuilder: {
                .password(.missingUppercase)
            }
            PredicateConstraint {
                .characterSet(.decimalDigits, mode: .inclusive)
            } errorBuilder: {
                .password(.missingDigits)
            }
            PredicateConstraint {
                .characterSet(CharacterSet(charactersIn: "!?@#$%^&*()|\\/<>,.~`_+-="), mode: .inclusive)
            } errorBuilder: {
                .password(.missingSpecialChars)
            }
            PredicateConstraint {
                .length(min: 8)
            }  errorBuilder: {
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
        PredicateConstraint(.email, error: .email)
    }
    KeyPathConstraint(\.age) {
        PredicateConstraint(.range(min: 14), error: .underAge)
    }
    KeyPathConstraint(\.website) {
        PredicateConstraint(.url, error: .website)
            .optional()
    }
}

let newResult = constraintBuilder.evaluate(with: user)

switch newResult {
case .success:
    print("Account successfully created 🥳")
case .failure(let summary):
    summary.errors.forEach {
        print($0)
    }
}

//: [Next](@next)
