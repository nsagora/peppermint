import Foundation

internal protocol Strategy {
    
    func evaluate<C: Constraint>(constraints: [C], with input: C.InputType) -> Result<Void, Summary<C.ErrorType>>
}

public struct CompoundConstraint<T, E: Error>: Constraint {
    
    public typealias InputType = T
    public typealias ErrorType = E
    
    private var constraints: [AnyConstraint<T, E>]
    private var evaluationStrategy: Strategy
    
    /**
     Returns the number of constraints in collection
     */
    public var count: Int { constraints.count }
    
    /**
    Create a new `AndCompoundConstraint` instance populated with a predefined list of `Constraints`
    
    - parameter constraints: `[Constraint]`
    */
    public static func allOf<C: Constraint>(_ constraints: [C]) -> CompoundConstraint where C.InputType == T, C.ErrorType == E {
        CompoundConstraint(allOf: constraints)
    }
    
    /**
    Create a new `AndCompoundConstraint` instance populated with a predefined list of `Constraints`
    
    - parameter constraints: `[Constraint]`
    */
    public static func allOf<C: Constraint>(_ constraints: C...) -> CompoundConstraint where C.InputType == T, C.ErrorType == E {
        CompoundConstraint(allOf: constraints)
    }
    
    /**
    Create a new `AndCompoundConstraint` instance populated with a predefined list of `Constraints`
    
    - parameter constraints: `[Constraint]`
    */
    public static func anyOf<C: Constraint>(_ constraints: [C]) -> CompoundConstraint where C.InputType == T, C.ErrorType == E {
        CompoundConstraint(anyOf: constraints)
    }
    
    /**
    Create a new `AndCompoundConstraint` instance populated with a predefined list of `Constraints`
    
    - parameter constraints: `[Constraint]`
    */
    public static func anyOf<C: Constraint>(_ constraints: C...) -> CompoundConstraint where C.InputType == T, C.ErrorType == E {
        CompoundConstraint(anyOf: constraints)
    }
    
    private init<C: Constraint>(allOf constraints: [C]) where C.InputType == T, C.ErrorType == E {
        self.constraints = constraints.map { $0.erase() }
        self.evaluationStrategy = AndStrategy()
    }
    
    private init<C: Constraint>(anyOf constraints: [C]) where C.InputType == T, C.ErrorType == E {
        self.constraints = constraints.map { $0.erase() }
        self.evaluationStrategy = OrStrategy()
    }
    
    /**
    Evaluates the input on the  sub-constraints.

    - parameter input: The input to be validated.
    - returns: `.success` if the input is valid,`.failure` containing the `Summary` of the failing `Constraint`s otherwise.
    */
    public func evaluate(with input: T) -> Result<Void, Summary<E>> {
        return evaluationStrategy.evaluate(constraints: constraints, with: input)
    }
}
