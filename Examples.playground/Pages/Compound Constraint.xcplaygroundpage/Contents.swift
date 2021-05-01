//: [Previous](@previous)

import Foundation
import Peppermint

/*:
 ## ConstraintSet
 
 In the following example we use a `ConstraintSet` to evaluate the strength of the user password.
 */

var passwordConstraint = CompoundConstraint<String, Form.Password>(.all, constraints:
    PredicateConstraint {
        CharacterSetPredicate(.lowercaseLetters, mode: .loose)
    } errorBuilder: {
        .missingLowercase
    },
    PredicateConstraint{
        CharacterSetPredicate(.uppercaseLetters, mode: .loose)
    } errorBuilder: {
        .missingUppercase
    },
    PredicateConstraint {
        CharacterSetPredicate(.decimalDigits, mode: .loose)
    } errorBuilder: {
        .missingDigits
    },
    PredicateConstraint {
        CharacterSetPredicate(CharacterSet(charactersIn: "!?@#$%^&*()|\\/<>,.~`_+-="), mode: .loose)
    } errorBuilder: {
        .missingSpecialChars
    },
    PredicateConstraint {
        LengthPredicate(min: 8)
    }  errorBuilder: {
        .minLength(8)
    }
)

let password = "3nGuard!"
let result = passwordConstraint.evaluate(with: password)

switch result {
case .success:
    print("Wow, that's a 💪 password!")
case .failure(let summary):
    print(summary.errors.map({$0.localizedDescription}))
}
