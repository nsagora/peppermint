import Foundation

/// A data type that links a `Predicate` to an `Error` that describes why the predicate evaluation has failed.
public class ConditionedConstraint<T>: Constraint {

    private let constraint: AnyConstraint<T>
    private var conditions = [AnyConstraint<T>]()
    
    private var hasConditions: Bool { conditionsCount > 0 }

    /**
        The number of conditions that must be evaluated i
    */
    public var conditionsCount: Int { conditions.count }

    /**
     Create a new `ConditionedConstraint` instance

     - parameter predicate: A `Predicate` to describes the evaluation rule.
     - parameter error: An `Error` that describes why the evaluation has failed.
     */
    public init<P>(predicate: P, error: Error) where T == P.InputType, P: Predicate {
        self.constraint = PredicateConstraint(predicate: predicate, error: error).erase()
    }
    /**
     Create a new `ConditionedConstraint` instance

     - parameter predicate: A `Predicate` to describes the evaluation rule.
     - parameter error: A generic closure that dynamically builds an `Error` to describe why the evaluation has failed.
     */
    public init<P>(predicate: P, error: @escaping (T) -> Error) where T == P.InputType, P: Predicate {
        self.constraint = PredicateConstraint(predicate: predicate, error: error).erase()
    }

    /**
     Add a condition `Constraint`.

     - parameter constraint: `Constraint`
     */
    public func add<C: Constraint>(condition: C) where C.InputType == T {
        conditions.append(condition.erase())
    }

    /**
     Add a predefined list of conditional `Constraints`.

     - parameter constraints: `[Constraint]`
     */
    public func add<C: Constraint>(conditions: [C]) where C.InputType == T {
        let constraits = conditions.map { $0.erase() }
        self.conditions.append(contentsOf: constraits)
    }

    /**
     A an unsized list of conditional `Constraints`.

     - parameter constraints: `[Constraint]`
     */
    public func add<C: Constraint>(conditions: C...) where C.InputType == T {
        self.add(conditions: conditions)
    }

    /**
     Evaluates the input on the `Predicate`.

     - parameter input: The input to be validated.
     - returns: `.success` if the input is valid,`.failure` containing the `Summary` of the failing `Constraint`s otherwise.
     */
    public func evaluate(with input: T) -> Result {

        guard hasConditions else { return constraint.evaluate(with: input) }

        let compound = CompoundContraint(allOf: conditions)
        let result = compound.evaluate(with: input)

        if result.isSuccessful {
            return constraint.evaluate(with: input)
        }

        return result
    }
}
