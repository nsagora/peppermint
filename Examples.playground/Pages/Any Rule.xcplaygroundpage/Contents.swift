//: [Previous](@previous)

import Foundation
import Peppermint

/*:
 ## `AnyRule`
 
 In the following example we erase the type of a `BlockRule` by creating an instance of an `AnyRule`.
 */

let odd = BlockRule<Int> {
   $0 % 2 != 0
}

let anyOdd = AnyRule<Int>(odd)
anyOdd.evaluate(with: 3)

/*:
 In the following example we erase the type of a `BlockRule` by calling the `.erase()` method.
 */

let erasedOdd = odd.erase()
erasedOdd.evaluate(with: 5)

//: [Next](@next)
