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
     Asynchronous evaluates the input against the receiver.

     - parameter input: The input to be validated.
     - returns: `.success` if the input is valid,`.failure` containing the `Summary` of the failing `Constraint`s otherwise.
     */
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func evaluate(with input: InputType) async -> Result<Void, Summary<ErrorType>>
    
    /**
     Asynchronous evaluates the input against the receiver. When the evaluation is successful, it return the `input`, otherwise it throws the `Summary` of the failing `Constraint`.
     
     - parameter input: The input to be validated.
     - Returns:The `input` when the validation is successful.
     - Throws: The `Summary` of the failing `Constraint`s when the validation fails.
     */
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func check(_ input: InputType) async throws -> InputType
}


public extension AsyncConstraint {
    
    /**
     Asynchronous evaluates the input against the receiver. When the evaluation is successful, it return the `input`, otherwise it throws the `Summary` of the failing `Constraint`.
     
     - parameter input: The input to be validated.
     - Returns:The `input` when the validation is successful.
     - Throws: The `Summary` of the failing `Constraint`s when the validation fails.
     */
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func check(_ input: InputType) async throws -> InputType {
        let result = await evaluate(with: input)
        switch result {
        case .success:
           return input
        case .failure(let summary):
            throw summary
        }
    }
}

