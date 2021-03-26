import Foundation

/**
 A data type that links a `Predicate` to an `Error` that describes why the predicate evaluation has failed.
 */
public struct ConditionedConstraint<T, E: Error>: Constraint {
    
    public typealias InputType = T
    public typealias ErrorType = E

    private let constraint: AnyConstraint<T, E>
    private var conditions = [AnyConstraint<T, E>]()
    
    private var hasConditions: Bool { conditionsCount > 0 }

    /**
     The number of conditions that must be evaluated i
    */
    public var conditionsCount: Int { conditions.count }

    /**
     Create a new `ConditionedConstraint` instance

     - parameter constraint: A `Constraint` to describes the evaluation rule.
     - parameter conditions: An array of `Constraints` that must fullfil before evaluating the constraint.
     */
    public init<C: Constraint>(_ constraint: C, conditions: [C]) where C.InputType == T, C.ErrorType == E {
        self.constraint = constraint.erase()
        self.conditions = conditions.map { $0.erase() }
    }
    
    /**
     Create a new `ConditionedConstraint` instance

     - parameter constraint: A `Constraint` to describes the evaluation rule.
     - parameter conditions: An array of `Constraints` that must fullfil before evaluating the constraint.
     */
    public init<C: Constraint>(_ constraint: C, conditions: C...) where C.InputType == T, C.ErrorType == E {
        self.init(constraint, conditions: conditions)
    }

    /**
     Evaluates the input on the `Predicate`.

     - parameter input: The input to be validated.
     - returns: `.success` if the input is valid,`.failure` containing the `Summary` of the failing `Constraint`s otherwise.
     */
    public func evaluate(with input: T) -> Result<Void, Summary<E>> {
        
        guard hasConditions else { return constraint.evaluate(with: input) }
        
        let compound = CompoundConstraint.allOf(conditions)
        let result = compound.evaluate(with: input)
        
        switch result {
        case .success: return constraint.evaluate(with: input)
        case .failure: return result
        }
    }
}
