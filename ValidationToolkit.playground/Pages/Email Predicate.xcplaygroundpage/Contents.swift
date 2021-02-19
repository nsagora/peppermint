//: [Previous](@previous)

import Foundation
import ValidationToolkit

/*:
 ## `EmailPredicate`
 
 In the following example we use a `EmailPredicate` to evaluate if a given email address is syntactically valid.
 */

let predicate = EmailPredicate()
predicate.evaluate(with: "hello@")
predicate.evaluate(with: "hello@nsagora.com")
predicate.evaluate(with: "héllo@nsagora.com")

//: [Next](@next)
