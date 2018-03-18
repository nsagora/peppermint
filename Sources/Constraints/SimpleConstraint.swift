import Foundation

/**
 A data type that links a `Predicate` to an `Error` that describes why the predicate evaluation has failed.
 */
public class SimpleConstraint<T>: Constraint {

    private let predicate:AnyPredicate<T>
    private let errorBuilder: (T)->Error

    /**
     Create a new `SimpleConstraint` instance
     
     - parameter predicate: A `Predicate` to describes the evaluation rule.
     - parameter error: An `Error` that describes why the evaluation has failed.
     */
    public init<P:Predicate>(predicate: P, error: Error) where P.InputType == T {
        self.predicate = predicate.erase()
        self.errorBuilder = { _ in return error }
    }
    
    /**
     Create a new `SimpleConstraint` instance
     
     - parameter predicate: A `Predicate` to describes the evaluation rule.
     - parameter error: A generic closure that dynamically builds an `Error` to describe why the evaluation has failed.
     */
    public init<P:Predicate>(predicate: P, error: @escaping (T)->Error) where P.InputType == T {
        self.predicate = predicate.erase()
        self.errorBuilder = error
    }
    
    /**
     Evaluates the input on the `Predicate`.
     
     - parameter input: The input to be validated.
     - returns: `.valid` if the input is valid,`.invalid` containing the `Result.Summary` of the failing `Constraint`s otherwise.
     */
    public func evaluate(with input:T) -> Result {
        
        let result = predicate.evaluate(with: input)
        
        if result == true {
            return .valid
        }
        
        let error = errorBuilder(input)
        let summary = Result.Summary(errors: [error])
        return .invalid(summary)
    }
}
