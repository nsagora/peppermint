import Foundation

internal protocol Strategy<InputType, ErrorType> {
    
    associatedtype InputType
    associatedtype ErrorType: Error
    
    
    func evaluate(constraints: [some Constraint<InputType, ErrorType>], with input: InputType) -> Result<Void, Summary<ErrorType>>
}

public struct GroupConstraint<T, E: Error>: Constraint {
    
    public enum Mode {
        /// Evaluates every constraint and collects all errors. All constraints must be satisfied.
        case allSatisfied
        /// Short-circuits on the first satisfied constraint. At least one constraint must be satisfied.
        case anySatisfied
        /// Short-circuits on the first unsatisfied constraint, returning only that error. All constraints must be satisfied.
        case firstUnsatisfied

        var strategy: any Strategy<T, E> {
            switch self {
            case .allSatisfied: return AllSatisfiedStrategy<T, E>()
            case .anySatisfied: return AnySatisfiedStrategy<T, E>()
            case .firstUnsatisfied: return FirstUnsatisfiedStrategy<T, E>()
            }
        }
    }
    
    public typealias InputType = T
    public typealias ErrorType = E
    
    private var constraints: [AnyConstraint<T, E>]
    private var evaluationStrategy: any Strategy<T, E>
    
    
    /// Returns the number of constraints in the group.
    public var count: Int { constraints.count }
    
    /**
     Returns a new `AndCompoundConstraint` instance populated with a predefined list of `Constraints`.
     
     - parameter constraints: `[Constraint]`
     */
    public init(_ mode: Mode = .allSatisfied, constraints: [some Constraint<T, E>]) {
        self.evaluationStrategy = mode.strategy
        self.constraints = constraints.map { $0.erase() }
    }
    
    /**
     Evaluates the input on the underlying constraints.
     
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
     Returns a new `GroupConstraint` instance populated with a predefined list of `Constraints`.
     
     - parameter constraints: `[Constraint]`
     */
    public init(_ mode: Mode = .allSatisfied, @ConstraintBuilder<T, E> constraintBuilder: () -> [AnyConstraint<T, E>])  {
        self.init(mode, constraints: constraintBuilder())
    }
}
