import Foundation

/**
 A structrure that links a `Predicate` to an `Error` that describes why the predicate evaluation has failed.
 */
public struct SimpleConstraint<T>: Constraint {

    private let predicate:AnyPredicate<T>
    private let errorBuilder: (T)->Error

    var conditions =  [SimpleConstraint<T>]()

    /**
     Create a new `Constraint` instance
     
     - parameter predicate: A `Predicate` to describes the evaluation rule.
     - parameter error: An `Error` that describes why the evaluation has failed.
     */
    public init<P:Predicate>(predicate: P, error: Error) where P.InputType == T {
        self.predicate = predicate.erase()
        self.errorBuilder = { _ in return error }
    }
    
    /**
     Create a new `Constraint` instance
     
     - parameter predicate: A `Predicate` to describes the evaluation rule.
     - parameter error: A generic closure that dynamically builds an `Error` to describe why the evaluation has failed.
     */
    public init<P:Predicate>(predicate: P, error: @escaping (T)->Error) where P.InputType == T {
        self.predicate = predicate.erase()
        self.errorBuilder = error
    }

    
    public mutating func add(condition:SimpleConstraint<T>) {
        conditions.append(condition)
    }
    
    /**
     Evaluates the input on the `Predicate`.
     
     - parameter input: The input to be validated.
     - returns: `.valid` if the input is valid or a `.invalid` containing the `Error` for the failing `Constraint` otherwise.
     */
    public func evaluate(with input:T) -> Result {
        
        if !hasConditions() {
            return continueEvaluation(with: input)
        }

        let constraintSet = ConstraintSet(constraints: conditions)
        let result = constraintSet.evaluateAll(input: input)

        if result.isValid {
            return continueEvaluation(with: input)
        }

        return result
    }
    
    func hasConditions() -> Bool {
        return conditions.count > 0
    }
    
    func continueEvaluation(with input:T) -> Result {
        
        let result = predicate.evaluate(with: input)
        
        if result == true {
            return .valid
        }
        else {
            let error = errorBuilder(input)
            let summary = Result.Summary(errors: [error])
            return .invalid(summary)
        }
    }
}
