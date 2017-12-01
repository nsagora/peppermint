import Foundation

public protocol ConstraintType {

    associatedtype InputType

    func evaluate(with input:InputType) -> Result
}

public struct AnyConstraint<T>:ConstraintType {

    private let _evaluate:(T) -> Result
    public typealias InputType = T

    public init<C:ConstraintType>(_ constraint:C) where C.InputType == T {
        _evaluate = constraint.evaluate
    }

    public func evaluate(with input: InputType) -> Result {
        return _evaluate(input)
    }
}

extension ConstraintType {

    internal func erase() -> AnyConstraint<InputType> {
        return AnyConstraint(self)
    }
}

/**
 A structrure that links a `Predicate` to an `Error` that describes why the predicate evaluation has failed.
 */
public struct Constraint<T>: ConstraintType {

    private let predicate:AnyPredicate<T>
    private let errorBuilder: (T)->Error

    var conditions =  [Constraint<T>]()

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

    
    public mutating func add(condition:Constraint<T>) {
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
