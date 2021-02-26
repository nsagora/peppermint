import Foundation

internal protocol Strategy {
    
    func evaluate<C: Constraint>(constraints: [C], with input: C.InputType) -> Result<Void, Summary<C.ErrorType>>
}

public struct CompoundContraint<T, E: Error>: Constraint {
    
    public typealias InputType = T
    public typealias ErrorType = E
    
    var constraints: [AnyConstraint<T, E>]
    var evaluationStrategy: Strategy
    
    /**
     Returns the number of constraints in collection
     */
    public var count: Int { constraints.count }
    
    /**
    Create a new `AndCompoundConstraint` instance populated with a predefined list of `Constraints`
    
    - parameter constraints: `[Constraint]`
    */
    public init<C: Constraint>(allOf constraints: [C]) where C.InputType == T, C.ErrorType == E {
        self.constraints = constraints.map { $0.erase() }
        self.evaluationStrategy = AndStrategy()
    }
    
    /**
    Create a new `AndCompoundConstraint` instance populated with a predefined list of `Constraints`
    
    - parameter constraints: `[Constraint]`
    */
    public init<C: Constraint>(allOf constraints: C...) where C.InputType == T, C.ErrorType == E {
        self.init(allOf: constraints)
    }
    
    /**
    Create a new `OrConstraint` instance populated with a predefined list of `Constraints`
    
    - parameter constraints: `[Constraint]`
    */
    public init<C: Constraint>(anyOf constraints: [C]) where C.InputType == T, C.ErrorType == E {
        self.constraints = constraints.map { $0.erase() }
        self.evaluationStrategy = OrStrategy()
    }
    
    /**
    Create a new `OrConstraint` instance populated with a predefined list of `Constraints`
    
    - parameter constraints: `[Constraint]`
    */
    public init<C: Constraint>(anyOf constraints: C...) where C.InputType == T, C.ErrorType == E {
        self.init(anyOf: constraints)
    }
    
    /**
    Evaluates the input on the  subconstraints.

    - parameter input: The input to be validated.
    - returns: `.success` if the input is valid,`.failure` containing the `Summary` of the failing `Constraint`s otherwise.
    */
    public func evaluate(with input: T) -> Result<Void, Summary<E>> {
        return evaluationStrategy.evaluate(constraints: constraints, with: input)
    }
}

// MARK: - Factory Methods

extension CompoundContraint {
    
    /**
    Create a new `AndCompoundConstraint` instance populated with a predefined list of `Constraints`
    
    - parameter constraints: `[Constraint]`
    */
    public static func allOf<C: Constraint>(_ constraints: [C]) -> CompoundContraint where C.InputType == T, C.ErrorType == E {
        CompoundContraint(allOf: constraints)
    }
    
    /**
    Create a new `AndCompoundConstraint` instance populated with a predefined list of `Constraints`
    
    - parameter constraints: `[Constraint]`
    */
    public static func allOf<C: Constraint>(_ constraints: C...) -> CompoundContraint where C.InputType == T, C.ErrorType == E {
        CompoundContraint(allOf: constraints)
    }
    
    /**
    Create a new `AndCompoundConstraint` instance populated with a predefined list of `Constraints`
    
    - parameter constraints: `[Constraint]`
    */
    public static func anyOf<C: Constraint>(_ constraints: [C]) -> CompoundContraint where C.InputType == T, C.ErrorType == E {
        CompoundContraint(anyOf: constraints)
    }
    
    /**
    Create a new `AndCompoundConstraint` instance populated with a predefined list of `Constraints`
    
    - parameter constraints: `[Constraint]`
    */
    public static func anyOf<C: Constraint>(_ constraints: C...) -> CompoundContraint where C.InputType == T, C.ErrorType == E {
        CompoundContraint(anyOf: constraints)
    }
}
