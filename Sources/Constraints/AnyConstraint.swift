import Foundation

/**
 A type-erased `Constraint`.
 */
public struct AnyConstraint<T, E: Error>: Constraint {

    /**
     A type that provides information about what kind of values the constraint can be evaluated with.
     */
    public typealias InputType = T
    public typealias ErrorType = E

    private let evaluate: (InputType) -> Result<Void, Summary>

    /**
     Creates a type-erased `Constraint` that wraps the given instance.
     */
    public init<C: Constraint>(_ constraint: C) where C.InputType == T {
        self.evaluate = constraint.evaluate
    }

    /**
     Evaluates the input against the receiver.

     - parameter input: The input to be validated.
     - returns: `.success` if the input is valid,`.failure` containing the `Summary` of the failing `Constraint`s otherwise.
     */
    public func evaluate(with input: T) -> Result<Void, Summary> {
        return evaluate(input)
    }
}

extension Constraint {

    internal func erase() -> AnyConstraint<InputType, ErrorType> {
        return AnyConstraint(self)
    }
}
