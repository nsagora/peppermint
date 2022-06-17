import Foundation

/**
 The `AsyncConstraint` protocol is used to define the structure that must be implemented by concrete asynchronous constraints.
 */
public protocol AsyncConstraint<InputType, ErrorType> {

    /// A type that provides information about what kind of values the constraint can be evaluated with.
    associatedtype InputType
    
    /// An error type that provides information about why the evaluation failed.
    associatedtype ErrorType: Error

    /**
     Asynchronous evaluates the input on the provided queue.

     - parameter input: The input to be validated.
     - parameter queue: The queue on which the completion handler is executed.
     - parameter completionHandler: The completion handler to call when the evaluation is complete. It takes a `Bool` parameter:
     - parameter result: `.success` if the input is valid, `.failure` containing the `Summary` of the failing `Constraint`s otherwise.
     */
    func evaluate(with input: InputType, queue: DispatchQueue, completionHandler: @escaping (_ result: Result<Void, Summary<ErrorType>>) -> Void)
}
