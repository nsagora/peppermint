import Foundation

/**
 A type that bridges a synchronous `Constraint` to the `AsyncConstraint` protocol.

 This allows sync constraints to be used in APIs that explicitly require an `AsyncConstraint`.
 Note that sync constraints can already be called directly from async contexts without this bridge —
 this is only needed when the call site explicitly types the value as `any AsyncConstraint`.
 */
public struct AsyncConstraintBridge<T, E: Error>: AsyncConstraint {

    public typealias InputType = T
    public typealias ErrorType = E

    private let constraint: any Constraint<T, E>

    fileprivate init(constraint: some Constraint<T, E>) {
        self.constraint = constraint
    }

    /**
     Evaluates the input against the underlying synchronous constraint.

     - parameter input: The input to be validated.
     - returns: `.success` if the input is valid, `.failure` containing the `Summary` of the failing `Constraint`s otherwise.
     */
    public func evaluate(with input: T) async -> Result<Void, Summary<E>> {
        constraint.evaluate(with: input)
    }
}

// MARK: - Constraint modifier

extension Constraint {

    /**
     Returns an `AsyncConstraint` that bridges this synchronous constraint to the `AsyncConstraint` protocol.

     ```swift
     let asyncConstraint = emailConstraint.async()
     let result = await asyncConstraint.evaluate(with: "hello@nsagora.com")
     ```

     - Returns: An `AsyncConstraintBridge` wrapping this constraint.
     */
    public func `async`() -> any AsyncConstraint<Self.InputType, Self.ErrorType> {
        AsyncConstraintBridge(constraint: self)
    }
}
