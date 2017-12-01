import Foundation

/**
 A type-erased `AsyncConstraint`.
 */
public struct AnyAsyncConstraint<T>:AsyncConstraint {

    /**
     A type that provides information about what kind of values the constraint can be evaluated with.
     */
    public typealias InputType = T

    private let _evaluate:(T, DispatchQueue, @escaping (Result) -> Void) -> Void

    /**
     Creates a type-erased `AsyncConstraint` that wraps the given instance.
     */
    public init<C:AsyncConstraint>(_ constraint:C) where C.InputType == T {
        _evaluate = constraint.evaluate
    }

    /**
     Asynchronous evaluates the input on the provided queue.

     - parameter input: The input to be validated.
     - parameter queue: The queue on which the completion handler is executed.
     - parameter completionHandler: The completion handler to call when the evaluation is complete. It takes a `Bool` parameter:
     - parameter result: `.valid` if the input is valid, `.invalid` containing the `Result.Summary` of the failing `Constraint`s otherwise.
     */
    public func evaluate(with input: T, queue: DispatchQueue, completionHandler: @escaping (_ result:Result) -> Void) {
        return _evaluate(input, queue, completionHandler)
    }
}

extension AsyncConstraint {

    internal func erase() -> AnyAsyncConstraint<InputType> {
        return AnyAsyncConstraint(self)
    }
}
