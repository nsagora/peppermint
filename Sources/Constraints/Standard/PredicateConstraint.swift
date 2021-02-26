import Foundation

/**
 A data type that links a `Predicate` to an `Error` that describes why the predicate evaluation has failed.
 */
public struct PredicateConstraint<T, E: Error>: Constraint {
    
    public typealias InputType = T
    public typealias ErrorType = E
    
    private let predicate: AnyPredicate<T>
    private let errorBuilder: (T) -> E

    /**
     Create a new `PredicateConstraint` instance
     
     - parameter predicate: A `Predicate` to describes the evaluation rule.
     - parameter error: An `Error` that describes why the evaluation has failed.
     */
    public init<P: Predicate>(predicate: P, error: E) where P.InputType == InputType {
        self.predicate = predicate.erase()
        self.errorBuilder = { _ in return error }
    }
    
    /**
     Create a new `PredicateConstraint` instance
     
     - parameter predicate: A `Predicate` to describes the evaluation rule.
     - parameter error: A generic closure that dynamically builds an `Error` to describe why the evaluation has failed.
     */
    public init<P: Predicate>(predicate: P, error: @escaping (T) -> E) where P.InputType == T {
        self.predicate = predicate.erase()
        self.errorBuilder = error
    }
    
    /**
     Evaluates the input on the `Predicate`.
     
     - parameter input: The input to be validated.
     - returns: `.success` if the input is valid,`.failure` containing the `Summary` of the failing `Constraint`s otherwise.
     */
    public func evaluate(with input: T) -> Result<Void, Summary<E>> {
        
        let result = predicate.evaluate(with: input)
        
        if result == true {
            return .success(())
        }
        
        let error = errorBuilder(input)
        let summary = Summary(errors: [error])
        return .failure(summary)
    }
}
