import Foundation

/**
 A `Constraint` that accepts an optional input and passes the unwrapped value to an underlying `Constraint`.
 
 ```swift
 enum Failure: Error {
     case required
     case invalidEmail
 }
 ```
 
 ```swift
 let email: String? = "hello@nsagora.com"
 let constraint = OptionalConstraint<String, Failure>(required: .required) {
     PredicateConstraint(.email, error: .invalidEmail)
 }

 let result = constraint.evaluate(with: email)
 ```
 */
public struct OptionalConstraint<T, E: Error>: Constraint {
    
    public typealias InputType = T?
    public typealias ErrorType = E
    
    private let constraint: AnyConstraint<T, E>
    private let requiredError: E?
    
    /**
     Returns a new `OptionalConstraint` instance.
     
     ```swift
     enum Failure: Error {
         case required
         case invalidEmail
     }
     ```
     
     ```swift
     let email: String? = "hello@nsagora.com"
     let emailConstraint = PredicateConstraint(.email, error: .invalidEmail)
     let constraint = OptionalConstraint<String, Failure>(required: .required, constraint: emailConstraint)

     let result = constraint.evaluate(with: email)
     
     - parameter required: An optional `Error` that marks the optional as mandatory.
     - parameter constraint: A `Constraint` to describes the evaluation rule for the unwrapped value of the input.
     */
    public init<C: Constraint>(required requiredError: E? = nil, constraint: C) where C.InputType == T, C.ErrorType == E {
        self.constraint = constraint.erase()
        self.requiredError = requiredError
    }
    
    
    /**
     Returns a new `OptionalConstraint` instance.
     
     ```swift
     enum Failure: Error {
         case required
         case invalidEmail
     }
     ```
     
     ```swift
     let email: String? = "hello@nsagora.com"
     let constraint = OptionalConstraint<String, Failure>(required: .required) {
         PredicateConstraint(.email, error: .invalidEmail)
     }

     let result = constraint.evaluate(with: email)
     
     - parameter required: An optional `Error` that marks the optional as mandatory.
     - parameter constraint: A closure that dynamically  builds a `Constraint` to describes the evaluation rule for the unwrapped value of the input.
     */
    public init<C: Constraint>(required requiredError: E? = nil, constraintBuilder: () -> C) where C.InputType == T, C.ErrorType == E {
        self.init(required: requiredError, constraint: constraintBuilder())
    }
    
    /**
     Evaluates the unwrapped input on the underlying constraint.
     
     - parameter input: The optional input to be validated.
     - returns: `.failure` with a `Summary` containing the required error when the optional is marked as required and the input is `nil`, `success` when the optional is not marked as required and the input is `nil`, the evaluation result from the underlying constraint otherwise.
     */
    public func evaluate(with input: T?) -> Result<Void, Summary<E>> {
        
        if let input = input {
            return constraint.evaluate(with: input)
        }
        
        if let requiredError = requiredError {
            return .failure(Summary(errors: [requiredError]))
        }
        
        return .success(())
    }
}

// MARK: - Constraint modifiers

extension Constraint {
    
    
    public func `optional`<T, E>(required requiredError: E? = nil) -> OptionalConstraint<T, E> where Self.ErrorType == E, Self.InputType == T{
        OptionalConstraint(required: requiredError, constraint: self)
    }
}
