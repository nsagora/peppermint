//: [Previous](@previous)

import Foundation
import Peppermint

/*:
 ## `TypeConstraint`
 
 In the following example we'll use a custom `FibonacciConstraint` to asyncronously evaluate if a given number is a Fibonacci number.
 */

enum FibonacciError: Swift.Error {
    case invalid
}

let constraint = FibonnaciConstraint<FibonacciError>(with: .invalid)

Task {
    print("Started at: \(Date.now)")
    do {
        let value = try await constraint.check(102334156)
        print("Hurray! \(value) is a Fibonacci number 🎉")
    } catch (_) {
        print("Not a Fibonacci number 😢")
    }
    print("Ended at: \(Date.now)")
}

//: [Next](@next)
