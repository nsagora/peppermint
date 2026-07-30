//: [Previous](@previous)

import Foundation
import Peppermint

/*:
 ## `GroupConstraint`
 
 In the following example we use a `GroupConstraint` to evaluate the strength of the user password.
 */

var passwordConstraint = GroupConstraint<String, Form.Password>(.allSatisfied) {
    RuleConstraint {
        .characterSet(.lowercaseLetters, mode: .inclusive)
    } errorBuilder: {
        .missingLowercase
    }
    RuleConstraint{
        .characterSet(.uppercaseLetters, mode: .inclusive)
    } errorBuilder: {
        .missingUppercase
    }
    RuleConstraint {
        .characterSet(.decimalDigits, mode: .inclusive)
    } errorBuilder: {
        .missingDigits
    }
    RuleConstraint {
        .characterSet(.specialChars, mode: .inclusive)
    } errorBuilder: {
        .missingSpecialChars
    }
    RuleConstraint {
        .length(min: 8)
    } errorBuilder: {
        .minLength(8)
    }
}

let password = "p@ssW0rd"
let result = passwordConstraint.evaluate(with: password)

switch result {
case .success:
    print("Wow, that's a 💪 password!")
case .failure(let summary):
    print(summary.errors.map({$0.localizedDescription}))
}
