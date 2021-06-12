//: [Previous](@previous)

import Foundation
import Peppermint

/*:
 ## Type Constraint
 
 In the following example we use a `TypeConstraint` to evaluate a data structure used in a registration form.
 */

struct RegistrationData {
    
    enum Error: Swift.Error {
        case username
        case password(Password)
        case email
        case underAge
    }
    
    enum Password {
        case missingUppercase
        case missingLowercase
        case missingDigits
        case missingSpecialChars
        case tooShort
    }
    
    var username: String
    var password: String
    var email: String
    var age: Int
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
            CharacterSetPredicate(.lowercaseLetters, mode: .inclusive)
        } errorBuilder: {
            .password(.missingLowercase)
        },
        PredicateConstraint{
            CharacterSetPredicate(.uppercaseLetters, mode: .inclusive)
        } errorBuilder: {
            .password(.missingUppercase)
        },
        PredicateConstraint {
            CharacterSetPredicate(.decimalDigits, mode: .inclusive)
        } errorBuilder: {
            .password(.missingDigits)
        },
        PredicateConstraint {
            CharacterSetPredicate(CharacterSet(charactersIn: "!?@#$%^&*()|\\/<>,.~`_+-="), mode: .inclusive)
        } errorBuilder: {
            .password(.missingSpecialChars)
        },
        PredicateConstraint {
            LengthPredicate(min: 8)
        }  errorBuilder: {
            .password(.tooShort)
        }
    )
}

constraint.set(for: \.email) {
    PredicateConstraint(EmailPredicate(), error: .email)
}

constraint.set(for: \.age) {
    PredicateConstraint(RangePredicate(min: 14), error: .underAge)
}

let user = RegistrationData(username: "nsagora", password: "p@ssW0rd", email: "hello@nsagora.com", age: 21)
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
                CharacterSetPredicate(.lowercaseLetters, mode: .inclusive)
            } errorBuilder: {
                .password(.missingLowercase)
            }
            PredicateConstraint{
                CharacterSetPredicate(.uppercaseLetters, mode: .inclusive)
            } errorBuilder: {
                .password(.missingUppercase)
            }
            PredicateConstraint {
                CharacterSetPredicate(.decimalDigits, mode: .inclusive)
            } errorBuilder: {
                .password(.missingDigits)
            }
            PredicateConstraint {
                CharacterSetPredicate(CharacterSet(charactersIn: "!?@#$%^&*()|\\/<>,.~`_+-="), mode: .inclusive)
            } errorBuilder: {
                .password(.missingSpecialChars)
            }
            PredicateConstraint {
                LengthPredicate(min: 8)
            }  errorBuilder: {
                .password(.tooShort)
            }
        }
    }
    KeyPathConstraint(\.email) {
        PredicateConstraint(EmailPredicate(), error: .email)
    }
    KeyPathConstraint(\.age) {
        PredicateConstraint(RangePredicate(min: 14), error: .underAge)
    }
}

//: [Next](@next)
