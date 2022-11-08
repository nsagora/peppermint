import Foundation

/**
 A `Constraint` that  check whether the input collection is empty.
 
 ```swift
 enum Failure: Error {
     case required
     case invalidEmail
 }
 ```
 
 ```swift
 let constraint = RequiredConstraint<String, Failure>(error: .required)
 let result = constraint.evaluate(with: "hello@nsagora.com")
 ```
 */
public struct RequiredConstraint<T: Collection, E: Error>: Constraint {
    
    private let predicate = RequiredPredicate<T>()
    private let errorBuilder: (T) -> E
  
    /**
     Returns a new `RequiredConstraint` instance.
     
     ```swift
     enum Failure: Error {
         case required
         case invalidEmail
     }
     ```
     
     ```swift
     let constraint = RequiredConstraint<String, Failure>(error: .required)
     let result = constraint.evaluate(with: "hello@nsagora.com")
     ```
     
     - parameter error: An `Error` that describes why the evaluation has failed.
     */
    public init(error: E) {
        self.errorBuilder = { _ in return error }
    }
   
    /**
     Returns a new `RequiredConstraint` instance.
     
     ```swift
     enum Failure: Error {
         case required
         case invalidEmail
     }
     ```
     
     ```swift
     let constraint = RequiredConstraint<String, Failure> { _ in .required }
     let result = constraint.evaluate(with: "hello@nsagora.com")
     ```
     
     - parameter error: A generic closure that dynamically builds an `Error` to describe why the evaluation has failed.
     */
    public init(errorBuilder: @escaping (T) -> E) {
        self.errorBuilder = errorBuilder
    }
    
    /**
     Returns a new `RequiredConstraint` instance.
     
     ```swift
     enum Failure: Error {
         case required
         case invalidEmail
     }
     ```
     
     ```swift
     let constraint = RequiredConstraint<String, Failure> { .required }
     let result = constraint.evaluate(with: "hello@nsagora.com")
     ```
     
     - parameter error: A generic closure that dynamically builds an `Error` to describe why the evaluation has failed.
     */
    public init(errorBuilder: @escaping () -> E) {
        self.errorBuilder = { _ in return errorBuilder() }
    }
    
    /**
     Evaluates whether the input collection is empty or not.
     
     - parameter input: The input collection to be validated.
     - returns: `.success` if the input is valid,`.failure` containing the `Summary` with the provided `Error`.
     */
    public func evaluate(with input: T) -> Result<Void, Summary<E>> {
        let result = predicate.evaluate(with: input)
        if result {
            return .success
        }
        
        let error = errorBuilder(input)
        return .failure(error)
    }
}
