//: [Previous](@previous)

import Foundation
import Peppermint

/*:
 ## `GroupConstraint`
 
 In the following example we use a `GroupConstraint` to evaluate the strength of the user password.
 */

var passwordConstraint = GroupConstraint<String, Form.Password>(.all, constraints:
    PredicateConstraint {
        CharacterSetPredicate(.lowercaseLetters, mode: .inclusive)
    } errorBuilder: {
        .missingLowercase
    },
    PredicateConstraint{
        CharacterSetPredicate(.uppercaseLetters, mode: .inclusive)
    } errorBuilder: {
        .missingUppercase
    },
    PredicateConstraint {
        CharacterSetPredicate(.decimalDigits, mode: .inclusive)
    } errorBuilder: {
        .missingDigits
    },
    PredicateConstraint {
        CharacterSetPredicate(CharacterSet(charactersIn: "!?@#$%^&*()|\\/<>,.~`_+-="), mode: .inclusive)
    } errorBuilder: {
        .missingSpecialChars
    },
    PredicateConstraint {
        LengthPredicate(min: 8)
    }  errorBuilder: {
        .minLength(8)
    }
)

let password = "p@ssW0rd"
let result = passwordConstraint.evaluate(with: password)

switch result {
case .success:
    print("Wow, that's a 💪 password!")
case .failure(let summary):
    print(summary.errors.map({$0.localizedDescription}))
}
