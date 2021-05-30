
import Foundation
import Peppermint

/*:
 ## `BlockPredicate`
 
 In the following example we use a `BlockPredicate` to evaluate if a given `Int` is even.
 */

let even = BlockPredicate<Int> { $0 % 2 == 0 }
let isEven = even.evaluate(with: 2)

if isEven {
    print("High 5️⃣!")
}
else {
    print("We're expecting an even number.")
}

//: [Next](@next)
