import Foundation

/**
 The `AsyncConstraint` protocol is used to define the structre that must be implemented by concrete asynchronous constraints.
 */
public protocol AsyncConstraint {

    /**
     A type that provides information about what kind of values the constraint can be evaluated with.
     */
    associatedtype InputType

    /**
     Asynchronous evaluates the input on the provided queue.

     - parameter input: The input to be validated.
     - parameter queue: The queue on which the completion handler is executed.
     - parameter completionHandler: The completion handler to call when the evaluation is complete. It takes a `Bool` parameter:
     - parameter result: `.success` if the input is valid, `.failure` containing the `Summary` of the failing `Constraint`s otherwise.
     */
    func evaluate(with input: InputType, queue: DispatchQueue, completionHandler: @escaping (_ result: ValidationResult) -> Void)
}
