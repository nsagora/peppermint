import Foundation

/**
 A type-erased `Rule`.
 
 ```swift
 let odd = BlockRule<Int> {
    $0 % 2 != 0
 }
 
 let anyOdd = AnyRule<Int>(odd)
 let isOdd = anyOdd.evaluate(with: 3)
 ```
 */
public struct AnyRule<T>: Rule {

    /**
     A type that provides information about what kind of values the rule can be evaluated with.
     */
    public typealias InputType = T

    var evaluate: (InputType) -> Bool

    /**
     Creates a type-erased `Rule` that wraps the given instance.
     
     ```swift
     let odd = BlockRule<Int> {
        $0 % 2 != 0
     }
     
     let anyOdd = AnyRule<Int>(odd)
     let isOdd = anyOdd.evaluate(with: 3)
     ```
    */
    public init<P: Rule>(_ rule: P) where P.InputType == InputType {
        self.evaluate = rule.evaluate
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

extension Rule {

    /**
     Wraps this rule with an `AnyRule`.
     
     ```swift
     let odd = BlockRule<Int> {
        $0 % 2 != 0
     }
     
     let erasedOdd = odd.erase()
     let isOdd = erasedOdd.evaluate(with: 3)
     ```
     
     - Returns:An `AnyRule` wrapping this rule.
     */
    public func erase() -> AnyRule<InputType> {
        return AnyRule(self)
    }
}
