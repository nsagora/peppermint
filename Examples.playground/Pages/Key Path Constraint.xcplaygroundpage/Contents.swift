//: [Previous](@previous)

import Foundation
import Peppermint

/*:
 ## `KeyPathConstraint`
 
 In the following example we use a `KeyPathConstraint` to evaluate that the `.email` property of the `LoginData` type is a valid email address.
 */

struct LoginData {
    
    enum Error: Swift.Error {
        case email
        case password
    }
    
    var email: String
    var password: String
}

let constraint = KeyPathConstraint<LoginData, String, LoginData.Error>(\.email) {
    PredicateConstraint(EmailPredicate(), error: .email)
}

let data = LoginData(email: "hello@nsagora.com", password: "p@ssW0rd")
let result = constraint.evaluate(with: data)

switch result {
case .success:
    print("You got 📬!")
case .failure(let summary):
    print(summary.errors.map({$0.localizedDescription}))
}

//: [Next](@next)
