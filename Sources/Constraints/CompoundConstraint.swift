import Foundation

internal protocol Strategy {
    func evaluate<C: Constraint>(constraints: [C], with input: C.InputType) -> Result
}

public struct CompoundContraint<T>: Constraint {
    
    public typealias InputType = T
    
    var constraints: [AnyConstraint<T>]
    var evaluationStrategy: Strategy
    
    /**
     Returns the number of constraints in collection
     */
    public var count: Int { constraints.count }
    
    /**
    Create a new `AndCompoundConstraint` instance populated with a predefined list of `Constraints`
    
    - parameter constraints: `[Constraint]`
    */
    public init<C: Constraint>(allOf subconstraints: [C]) where C.InputType == T {
        self.constraints = subconstraints.map { $0.erase() }
        self.evaluationStrategy = AndStrategy()
    }
    
    /**
    Create a new `AndCompoundConstraint` instance populated with a predefined list of `Constraints`
    
    - parameter constraints: `[Constraint]`
    */
    public init<C: Constraint>(allOf subconstraints: C...) where C.InputType == T {
        self.init(allOf: subconstraints)
    }
    
    /**
    Create a new `OrConstraint` instance populated with a predefined list of `Constraints`
    
    - parameter constraints: `[Constraint]`
    */
    public init<C: Constraint>(anyOf subconstraints: [C]) where C.InputType == T {
        self.constraints = subconstraints.map { $0.erase() }
        self.evaluationStrategy = OrStrategy()
    }
    
    /**
    Create a new `OrConstraint` instance populated with a predefined list of `Constraints`
    
    - parameter constraints: `[Constraint]`
    */
    public init<C: Constraint>(anyOf subconstraints: C...) where C.InputType == T {
        self.init(anyOf: subconstraints)
    }
    
    /**
    Evaluates the input on the  subconstraints.

    - parameter input: The input to be validated.
    - returns: `.success` if the input is valid,`.failure` containing the `Summary` of the failing `Constraint`s otherwise.
    */
    public func evaluate(with input: T) -> Result {
        return evaluationStrategy.evaluate(constraints: constraints, with: input)
    }
}
