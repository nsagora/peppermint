import Foundation

/**
 A generic collection of `Constraints` on which an input can be validated on.
 */
public struct ConstraintSet<T> {

    var constraints: [AnyConstraint<T>]

    /**
     Returns the number of constraints in collection
    */
    public var count: Int {
        return constraints.count
    }
    
    /**
     Create a new `ConstraintSet` instance
     */
    public init() {
        constraints = [AnyConstraint<T>]()
    }
    
    /**
     Create a new `ConstraintSet` instance populated with a predefined list of `Constraints`
     
     - parameter constraints: `[Constraint]`
     */
    public init<C: Constraint>(constraints: [C]) where C.InputType == T {
        self.constraints = constraints.map { $0.erase() }
    }

    /**
     Create a new `ConstraintSet` instance populated with a unsized list of `Constraints`
     
     - parameter constraints: `[Constraint]`
     */
    public init<C: Constraint>(constraints: C...) where C.InputType == T {
        self.init(constraints:constraints)
    }
}

public extension ConstraintSet {

    /**
     Adds a `Constraint` to the generic collection of constraints.
     
     - parameter constraint: `Constraint`
     */
     mutating func add<C: Constraint>(constraint: C) where C.InputType == T {
        constraints.append(constraint.erase())
    }
}

public extension ConstraintSet {

    /**
     Evaluates the input on all `Constraints` until the first fails.
     
     - parameter input: The input to be validated.
     - returns: `.success` if the input is valid, `.failure` containing the `Error` registered with the failing `Constraint` otherwise.
     */
    func evaluateAny(input: T) -> ValidationResult {
        
        return constraints.reduce(.success) { $0.isFailed ? $0 : $1.evaluate(with: input) }
    }

    /**
     Evaluates the input on all `Constraints in the collection.
     
     - parameter input: The input to be validated.
     - returns: An array of `Result` elements, indicating the evaluation result of each `Constraint` in collection.
     */
    func evaluateAll(input: T) -> ValidationResult {

        let results = constraints.map{ $0.evaluate(with:input) }
        let summary = ValidationResult.Summary(evaluationResults: results)

        return ValidationResult(summary: summary)
    }
}
