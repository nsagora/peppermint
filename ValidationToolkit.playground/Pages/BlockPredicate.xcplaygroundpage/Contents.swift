//: [Introduction](@previous)

import Foundation
import ValidationToolkit

/*:
 ## `BlockPredicate`
 Use a `BlockPredicate` to evaluate if the length of the user input is equal to 5 characters.
 */

let input = "Hel!O"
let predicate = BlockPredicate<String> { $0.characters.count == 5 }
let isValid = predicate.evaluate(with: input)

if isValid {
    print("Input is valid.")
}
else {
    print("We're expecting exactlly 5 characters.")
}

//: [RegexPredicate](@next)
