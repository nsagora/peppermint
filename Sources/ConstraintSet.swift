import Foundation

/**
 A generic collection of `Constraints` on which an input can be validated on.
 */
public struct ConstraintSet<T> {

    var constraints:[AnyConstraint<T>]

    /**
     Returns the number of constraints in collection
    */
    public var count:Int {
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
    public init<C:ConstraintType>(constraints:[C]) where C.InputType == T {
        self.constraints = constraints.map { $0.erase() }
    }

    /**
     Create a new `ConstraintSet` instance populated with a unsized list of `Constraints`
     
     - parameter constraints: `[Constraint]`
     */
    public init<C:ConstraintType>(constraints:C...) where C.InputType == T {
        self.init(constraints:constraints)
    }
}

extension ConstraintSet {

    /**
     Adds a `Constraint` to the generic collection of constraints.
     
     - parameter constraint: `Constraint`
     */
    public mutating func add<C:ConstraintType>(constraint:C) where C.InputType == T {
        constraints.append(constraint.erase())
    }

    /**
     Adds a `Constraint` to the generic collection of constraints.
     
     - parameter predicate: A `Predicate` to describes the evaluation rule.
     - parameter message: An `Error` that describes why the evaluation has failed.
     */
    public mutating func add<P:Predicate>(predicate:P, error:Error) where P.InputType == T {
        let constraint = Constraint(predicate: predicate, error: error)
        add(constraint: constraint)
    }
}

extension ConstraintSet {

    /**
     Evaluates the input on all `Constraints` until the first fails.
     
     - parameter input: The input to be validated.
     - returns: `.valid` if the input is valid, `.invalid` containing the `Error` registered with the failing `Constraint` otherwise.
     */
    public func evaluateAny(input:T) -> Result {
        
        return constraints.reduce(.valid) { $0.isInvalid ? $0 : $1.evaluate(with: input) }
    }

    /**
     Evaluates the input on all `Constraints in the collection.
     
     - parameter input: The input to be validated.
     - returns: An array of `Result` elements, indicating the evaluation result of each `Constraint` in collection.
     */
    public func evaluateAll(input:T) -> Result {

        let results = constraints.map{ $0.evaluate(with:input) }
        let summary = Result.Summary(evaluationResults: results)

        return Result(summary: summary)
    }
}
