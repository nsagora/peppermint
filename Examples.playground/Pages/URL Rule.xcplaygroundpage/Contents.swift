//: [Previous](@previous)

import Foundation
import Peppermint

/*:
 ## `URLRule`
 
 In the following example we use a `URLRule` to evaluate if a given URL is syntactically valid.
 */

let rule = URLRule()
rule.evaluate(with: "http://www.url.com")
rule.evaluate(with: "http:\\www.url.com")
rule.evaluate(with: "dfsadfdasfdsfads")

//: [Next](@next)
