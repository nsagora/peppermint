//: [Previous](@previous)

import Foundation
import Peppermint

/*:
 ## Custom Predicate
 
 In the following example we define a custom predicate which evaluates if the user input is equal to custom text.
 */

public struct CopyCatPredicate: Predicate {

    private let value: String

    public init(value: String) {
        self.value = value
    }

    public func evaluate(with input: String) -> Bool {
        return input == value
    }
}

let predicate = CopyCatPredicate(value: "alphabet")
predicate.evaluate(with: "alp") // returns false
predicate.evaluate(with: "alpha") // returns false
predicate.evaluate(with: "alphabet") // returns true

//: [Next](@next)
