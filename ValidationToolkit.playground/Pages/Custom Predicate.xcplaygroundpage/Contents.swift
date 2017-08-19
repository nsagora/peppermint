//: [Previous](@previous)

import Foundation
import ValidationToolkit

/*:
 ## Custom Predicate
 
 In the following example we define a custom predicate which evaluates if the length of the user input is equal to 5 characters.
 */

public class MinLenghtPredicate: Predicate {
    
    public typealias InputType = String
    
    private let minLenght:Int
    
    public init(minLenght:Int) {
        self.minLenght = minLenght
    }
    
    public func evaluate(with input: String) -> Bool {
        return input.characters.count >= minLenght
    }
}

let input = "alphabet"
let predicate = MinLenghtPredicate(minLenght: 5)
let isValid = predicate.evaluate(with: input)

if isValid {
    print("That's what I call a long ⛓ of characters!")
}
else {
    print("Expecting at least 5 digits.")
}

//: [Next](@next)
