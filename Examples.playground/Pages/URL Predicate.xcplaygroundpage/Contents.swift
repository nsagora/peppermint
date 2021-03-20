//: [Previous](@previous)

import Foundation
import Peppermint

/*:
 ## `URLPredicate`
 
 In the following example we use a `URLPredicate` to evaluate if a given URL is syntactically valid.
 */

let predicate = URLPredicate()
predicate.evaluate(with: "http://www.url.com")
predicate.evaluate(with: "http:\\www.url.com")

//: [Next](@next)
