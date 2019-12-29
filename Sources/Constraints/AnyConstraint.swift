import Foundation

/**
 A type-erased `Constraint`.
 */
public struct AnyConstraint<T>:Constraint {

    /**
     A type that provides information about what kind of values the constraint can be evaluated with.
     */
    public typealias InputType = T

    private let _evaluate: (InputType) -> Result

    /**
     Creates a type-erased `Constraint` that wraps the given instance.
     */
    public init<C: Constraint>(_ constraint: C) where C.InputType == InputType {
        _evaluate = constraint.evaluate
    }

    /**
     Evaluates the input against the receiver.

     - parameter input: The input to be validated.
     - returns: `.success` if the input is valid,`.failure` containing the `Summary` of the failing `Constraint`s otherwise.
     */
    public func evaluate(with input: InputType) -> Result {
        return _evaluate(input)
    }
}

extension Constraint {

    internal func erase() -> AnyConstraint<InputType> {
        return AnyConstraint(self)
    }
}
