//: [Previous](@previous)

import Foundation
import Peppermint

/*:
 ## Custom Predicate
 
 In the following example we define a custom predicate which evaluates if the user input is equal to custom text.
 */

public struct CustomPredicate: Predicate {

    public typealias InputType = String

    private let custom: String

    public init(custom: String) {
        self.custom = custom
    }

    public func evaluate(with input: String) -> Bool {
        return input == custom
    }
}

let predicate = CustomPredicate(custom: "alphabet")
predicate.evaluate(with: "alp") // returns false
predicate.evaluate(with: "alpha") // returns false
predicate.evaluate(with: "alphabet") // returns true

//: [Next](@next)
