import Foundation

extension ConstraintSet {

    /**
     Builds a `PredicateConstraint` instance and adds it to the generic collection of constraints.

     - parameter predicate: A `Predicate` to describes the evaluation rule.
     - parameter message: An `Error` that describes why the evaluation has failed.
     */
    public mutating func add<P:Predicate>(predicate:P, error:Error) where P.InputType == T {
        let constraint = PredicateConstraint(predicate: predicate, error: error)
        add(constraint: constraint)
    }
}
