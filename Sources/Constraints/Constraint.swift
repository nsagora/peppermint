import Foundation

/**
 The `Constraint` protocol is used to define the structure that must be implemented by concrete constraints.
 */
public protocol Constraint<InputType, ErrorType>: AsyncConstraint {
    
    /// A type that provides information about what kind of values the constraint can be evaluated with.
    associatedtype InputType
    
    /// An error type that provides information about why the evaluation failed.
    associatedtype ErrorType
    
    /**
     Evaluates the input against the receiver.

     - parameter input: The input to be validated.
     - returns: `.success` if the input is valid,`.failure` containing the `Summary` of the failing `Constraint`s otherwise.
     */
    func evaluate(with input: InputType) -> Result<Void, Summary<ErrorType>>
    
    /**
     Evaluates the input against the receiver. When the evaluation is successful, it return the `input`, otherwise it throws the `Summary` of the failing `Constraint`.
     
     - parameter input: The input to be validated.
     - Returns:The `input` when the validation is successful.
     - Throws: The `Summary` of the failing `Constraint`s when the validation fails.
     */
    func check(_ input: InputType) throws -> InputType
}

public extension Constraint {
    
    
    /**
     Evaluates the input against the receiver. When the evaluation is successful, it return the `input`, otherwise it throws the `Summary` of the failing `Constraint`.
     
     - parameter input: The input to be validated.
     - Returns:The `input` when the validation is successful.
     - Throws: The `Summary` of the failing `Constraint`s when the validation fails.
     */
    func check(_ input: InputType) throws -> InputType {
        let result = evaluate(with: input)
        switch result {
        case .success:
            return input
        case .failure(let summary):
            throw summary
        }
    }
}

public extension Constraint {

    private var workQueue: DispatchQueue {
        return DispatchQueue(label: "com.nsagora.peppermint.constraint", attributes: .concurrent)
    }

    /**
     Asynchronous evaluates the input against the receiver.

     - parameter input: The input to be validated.
     - parameter queue: The queue on which the completion handler is executed.
     - parameter completionHandler: The completion handler to call when the evaluation is complete. It takes a `Bool` parameter:
     - parameter result: `.success` if the input is valid, `.failure` containing the `Summary` of the failing `Constraint`s otherwise.
     */
     func evaluate(with input: InputType, queue: DispatchQueue, completionHandler: @escaping (_ result: Result<Void, Summary<ErrorType>>) -> Void) {

        workQueue.async {
            let result = self.evaluate(with: input)

            queue.async {
                completionHandler(result)
            }
        }
    }
    
    /**
     Asynchronous evaluates the input against the receiver.

     - parameter input: The input to be validated.
     - returns: `.success` if the input is valid,`.failure` containing the `Summary` of the failing `Constraint`s otherwise.
     */
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func evaluate(with input: InputType) async -> Result<Void, Summary<ErrorType>> {
        await Task {
            evaluate(with: input)
        }.value
    }
}
