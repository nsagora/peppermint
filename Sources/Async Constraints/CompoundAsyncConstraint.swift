import Foundation

internal protocol AsyncStrategy {
    
    func evaluate<C: AsyncConstraint>(constraints: [C], with input: C.InputType, queue: DispatchQueue, completionHandler: @escaping (Result) -> Void)
}

public struct CompoundAsyncConstraint<T>: AsyncConstraint {
    
    public typealias InputType = T
    
    var constraints: [AnyAsyncConstraint<T>]
    var evaluationStrategy: AsyncStrategy
    
    /**
     Returns the number of constraints in collection
     */
    var count: Int { constraints.count }
    
    /**
     Create a new `AsyncAndCompoundConstraint` instance populated with a predefined list of `AsyncConstraints`
     
     - parameter constraints: `[AsyncConstraint]`
     */
    public init<C: AsyncConstraint>(allOf subconstraints: [C]) where C.InputType == T {
        self.constraints = subconstraints.map { $0.erase() }
        self.evaluationStrategy = AndStrategy()
    }
    
    /**
     Create a new `AsyncAndCompoundConstraint` instance populated with a unsized list of `AsyncConstraints`
     
     - parameter constraints: `[AsyncConstraint]`
     */
    public init<C: AsyncConstraint>(allOf subconstraints: C...) where C.InputType == T {
        self.init(allOf: subconstraints)
    }
    
    /**
    Create a new `AsyncAndCompoundConstraint` instance populated with a predefined list of `AsyncConstraints`
    
    - parameter constraints: `[AsyncConstraint]`
    */
    public init<C: AsyncConstraint>(anyOf subconstraints: [C]) where C.InputType == T {
        self.constraints = subconstraints.map { $0.erase() }
        self.evaluationStrategy = OrStrategy()
    }
    
    /**
    Create a new `AsyncAndCompoundConstraint` instance populated with a unsized list of `AsyncConstraints`
    
    - parameter constraints: `[AsyncConstraint]`
    */
    public init<C: AsyncConstraint>(anyOf subconstraints: C...)  where C.InputType == T {
        self.init(anyOf: subconstraints)
    }
    
    public func evaluate(with input: T, queue: DispatchQueue = .main, completionHandler: @escaping (Result) -> Void) {
        evaluationStrategy.evaluate(constraints: constraints, with: input, queue: queue, completionHandler: completionHandler)
    }
}
