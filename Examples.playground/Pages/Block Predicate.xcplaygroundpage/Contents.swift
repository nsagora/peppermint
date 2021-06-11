
import Foundation
import Peppermint

/*:
 ## `BlockPredicate`
 
 In the following example we use a `BlockPredicate` to evaluate if a given `Int` is even.
 */

let even = BlockPredicate<Int> { $0 % 2 == 0 }
even.evaluate(with: 2)
even.evaluate(with: 3)

//: [Next](@next)
