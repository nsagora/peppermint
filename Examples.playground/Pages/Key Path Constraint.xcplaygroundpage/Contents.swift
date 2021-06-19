//: [Previous](@previous)

import Foundation
import Peppermint

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
constraint.evaluate(with: data)


//: [Next](@next)
