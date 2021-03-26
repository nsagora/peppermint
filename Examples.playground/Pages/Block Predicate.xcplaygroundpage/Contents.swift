
import Foundation
import Peppermint

/*:
 ## `BlockPredicate`
 
 In the following example we use a `BlockPredicate` to evaluate if the length of the user input is equal to 5 characters.
 */

let input = "Hel!O"
let predicate = BlockPredicate<String> { $0.count == 5 }
let isValid = predicate.evaluate(with: input)

if isValid {
    print("High ✋!")
}
else {
    print("We're expecting exactly 5 characters.")
}

//: [Next](@next)
