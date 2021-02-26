import Foundation

/**
 A type-erased `Predicate`.
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
     Creates a type-erased `Predicate` that wraps the given instance.
     */
    internal func erase() -> AnyPredicate<InputType> {
        return AnyPredicate(self)
    }
}
