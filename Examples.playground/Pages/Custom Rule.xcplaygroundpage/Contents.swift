//: [Previous](@previous)

import Foundation
import Peppermint

/*:
 ## Custom Rule
 
 In the following example we define a custom rule which evaluates if the user input is equal to custom text.
 */

public struct CopyCatRule: Rule {

    private let value: String

    public init(value: String) {
        self.value = value
    }

    public func evaluate(with input: String) -> Bool {
        return input == value
    }
}

let rule = CopyCatRule(value: "alphabet")
rule.evaluate(with: "alp") // returns false
rule.evaluate(with: "alpha") // returns false
rule.evaluate(with: "alphabet") // returns true

//: [Next](@next)
