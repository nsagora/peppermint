import Foundation

/**
 A data type that links a `Predicate` to an `Error` that describes why the predicate evaluation has failed.
 */
public class ConditionedConstraint<T>: PredicateConstraint<T> {

    private var conditions =  [AnyConstraint<T>]()

    /**
        The number of conditions that must be evaluated i
    */
    public var conditionsCount: Int { conditions.count }
    
    private var hasConditions: Bool { conditionsCount > 0 }

    /**
     Create a new `ConditionedConstraint` instance

     - parameter predicate: A `Predicate` to describes the evaluation rule.
     - parameter error: An `Error` that describes why the evaluation has failed.
     */
    public override init<P>(predicate: P, error: Error) where T == P.InputType, P: Predicate {
        super.init(predicate: predicate, error: error)
    }
    /**
     Create a new `ConditionedConstraint` instance

     - parameter predicate: A `Predicate` to describes the evaluation rule.
     - parameter error: A generic closure that dynamically builds an `Error` to describe why the evaluation has failed.
     */
    public override init<P>(predicate: P, error: @escaping (T) -> Error) where T == P.InputType, P : Predicate {
        super.init(predicate: predicate, error: error)
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
    public override func evaluate(with input: T) -> ValidationResult {

        guard hasConditions else { return super.evaluate(with: input) }

        let constraint = CompoundContraint.andConstraintWith(subconstraints: conditions)
        let result = constraint.evaluate(with: input)

        if result.isSuccessful {
            return super.evaluate(with: input)
        }

        return result
    }
}
