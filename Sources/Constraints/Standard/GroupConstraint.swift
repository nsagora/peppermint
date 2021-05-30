import Foundation

internal protocol Strategy {
    
    func evaluate<C: Constraint>(constraints: [C], with input: C.InputType) -> Result<Void, Summary<C.ErrorType>>
}

public struct GroupConstraint<T, E: Error>: Constraint {
    
    public enum Mode {
        case any
        case all
        
        var strategy: Strategy {
            switch self {
            case .all: return AllStrategy()
            case .any: return AnyStrategy()
            }
        }
    }
    
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
    public init<C: Constraint>(_ mode: Mode = .all, constraints: [C]) where C.InputType == T, C.ErrorType == E {
        self.evaluationStrategy = mode.strategy
        self.constraints = constraints.map { $0.erase() }
    }
    
    /**
     Create a new `AndCompoundConstraint` instance populated with a predefined list of `Constraints`
     
     - parameter constraints: `[Constraint]`
     */
    public init<C: Constraint>(_ mode: Mode = .all, constraints: C...) where C.InputType == T, C.ErrorType == E {
        self.evaluationStrategy = mode.strategy
        self.constraints = constraints.map { $0.erase() }
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

// MARK: - ConstraintBuilder Extension

extension GroupConstraint {
    
    /**
     Create a new `GroupConstraint` instance populated with a predefined list of `Constraints`
     
     - parameter constraints: `[Constraint]`
     */
    public init(_ mode: Mode = .all, @ConstraintBuilder<T, E> constraintBuilder: () -> [AnyConstraint<T, E>])  {
        self.init(mode, constraints: constraintBuilder())
    }
}
