//: [Previous](@previous)

import Foundation
import Peppermint

/*:
 ## `GroupConstraint`
 
 In the following example we use a `GroupConstraint` to evaluate the strength of the user password.
 */

var passwordConstraint = GroupConstraint<String, Form.Password>(.all, constraints:
    PredicateConstraint {
        .characterSet(.lowercaseLetters, mode: .inclusive)
    } errorBuilder: {
        .missingLowercase
    },
    PredicateConstraint{
        .characterSet(.uppercaseLetters, mode: .inclusive)
    } errorBuilder: {
        .missingUppercase
    },
    PredicateConstraint {
        .characterSet(.decimalDigits, mode: .inclusive)
    } errorBuilder: {
        .missingDigits
    },
    PredicateConstraint {
        .characterSet(CharacterSet(charactersIn: "!?@#$%^&*()|\\/<>,.~`_+-="), mode: .inclusive)
    } errorBuilder: {
        .missingSpecialChars
    },
    PredicateConstraint {
        .length(min: 8)
    } errorBuilder: {
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
