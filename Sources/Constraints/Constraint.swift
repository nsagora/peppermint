import Foundation

/**
 The `Constraint` protocol is used to define the structre that must be implemented by concrete constraints.
 */
public protocol Constraint: AsyncConstraint {

    /**
     A type that provides information about what kind of values the constraint can be evaluated with.
     */
    associatedtype InputType

    /**
     An error type that provides information about why the evaluation failed.
     */
    associatedtype ErrorType: Error
    
    /**
     Evaluates the input against the receiver.

     - parameter input: The input to be validated.
     - returns: `.success` if the input is valid,`.failure` containing the `Summary` of the failing `Constraint`s otherwise.
     */
    func evaluate(with input: InputType) -> Result<Void, Summary>
}

public extension Constraint {

    private var workQueue: DispatchQueue {
        return DispatchQueue(label: "com.nsagora.validation-toolkit.constraint", attributes: .concurrent)
    }

    /**
     Asynchronous evaluates the input against the receiver.

     - parameter input: The input to be validated.
     - parameter queue: The queue on which the completion handler is executed.
     - parameter completionHandler: The completion handler to call when the evaluation is complete. It takes a `Bool` parameter:
     - parameter result: `.success` if the input is valid, `.failure` containing the `Summary` of the failing `Constraint`s otherwise.
     */
     func evaluate(with input: InputType, queue: DispatchQueue, completionHandler: @escaping (_ result: Result<Void, Summary>) -> Void) {

        workQueue.async {
            let result = self.evaluate(with: input)

            queue.async {
                completionHandler(result)
            }
        }
    }
}
