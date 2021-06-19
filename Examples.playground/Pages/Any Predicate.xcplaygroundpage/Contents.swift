//: [Previous](@previous)

import Foundation
import Peppermint

/*:
 ## `AnyPredicate`
 
 In the following example we erase the type of a `BlockPredicate` by creating an instance of an `AnyPredicate`.
 */

let odd = BlockPredicate<Int> {
   $0 % 2 != 0
}

let anyOdd = AnyPredicate<Int>(odd)
anyOdd.evaluate(with: 3)

/*:
 In the following example we erase the type of a `BlockPredicate` by calling the `.erase()` method.
 */

let erasedOdd = odd.erase()
erasedOdd.evaluate(with: 5)

//: [Next](@next)
