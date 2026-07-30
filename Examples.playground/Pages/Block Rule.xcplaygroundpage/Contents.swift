
import Foundation
import Peppermint

/*:
 ## `BlockRule`
 
 In the following example we use a `BlockRule` to evaluate if a given `Int` is even.
 */

let even = BlockRule<Int> { $0 % 2 == 0 }
even.evaluate(with: 2)
even.evaluate(with: 3)

//: [Next](@next)
