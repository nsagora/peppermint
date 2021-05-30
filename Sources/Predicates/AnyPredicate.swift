import Foundation

/**
 A type-erased `Predicate`.
 
 ```swift
 let odd = BlockPredicate<Int> {
    $0 % 2 != 0
 }
 
 let anyOdd = AnyPredicate<Int>(odd)
 let isOdd = anyOdd.evaluate(with: 3)
 ```
 */
public struct AnyPredicate<T>: Predicate {

    /**
     A type that provides information about what kind of values the predicate can be evaluated with.
     */
    public typealias InputType = T

    var evaluate: (InputType) -> Bool

    /**
     Creates a type-erased `Predicate` that wraps the given instance.
    */
    public init<P: Predicate>(_ predicate: P) where P.InputType == InputType {
        self.evaluate = predicate.evaluate
    }

    /**
     Returns a `Boolean` value that indicates whether a given input matches the conditions specified by the receiver.

     - parameter input: The input against which to evaluate the receiver.
     - returns: `true` if input matches the conditions specified by the receiver, `false` otherwise.
     */
    public func evaluate(with input: InputType) -> Bool {
        return evaluate(input)
    }
}

extension Predicate {

    /**
     Wraps this predicate with an `AnyPredicate`.
     
     ```swift
     let odd = BlockPredicate<Int> {
        $0 % 2 != 0
     }
     
     let erasedOdd = odd.erase()
     let isOdd = erasedOdd.evaluate(with: 3)
     ```
     
     - Returns:An `AnyPredicate` wrapping this predicate.
     */
    public func erase() -> AnyPredicate<InputType> {
        return AnyPredicate(self)
    }
}
