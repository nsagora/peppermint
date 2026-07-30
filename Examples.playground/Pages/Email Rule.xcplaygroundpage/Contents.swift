//: [Previous](@previous)

import Foundation
import Peppermint

/*:
 ## `EmailRule`
 
 In the following example we use a `EmailRule` to evaluate if a given email address is syntactically valid.
 */

let rule = EmailRule()
rule.evaluate(with: "hello@")
rule.evaluate(with: "hello@nsagora.com")
rule.evaluate(with: "héllo@nsagora.com")

//: [Next](@next)
