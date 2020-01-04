import Foundation

public struct CompoundAsyncConstraint<T>: AsyncConstraint {
    
    public typealias InputType = T
    
    private init() { }
    
    public func evaluate(with input: T, queue: DispatchQueue, completionHandler: @escaping (Result) -> Void) {
        fatalError()
    }
}

extension CompoundAsyncConstraint {
    
    /**
     Create a new `AsyncAndCompoundConstraint` instance populated with a predefined list of `AsyncConstraints`
     
     - parameter constraints: `[AsyncConstraint]`
     */
    public static func and<C: AsyncConstraint>(subconstraints: [C]) -> AndAsyncConstraint<T> where C.InputType == T {
        return AndAsyncConstraint(constraints: subconstraints)
    }
    
    /**
     Create a new `AsyncAndCompoundConstraint` instance populated with a unsized list of `AsyncConstraints`
     
     - parameter constraints: `[AsyncConstraint]`
     */
    public static func and<C: AsyncConstraint>(subconstraints: C...) -> AndAsyncConstraint<T> where C.InputType == T {
        return AndAsyncConstraint(constraints: subconstraints)
    }
}

extension CompoundAsyncConstraint {
    
    /**
    Create a new `AsyncAndCompoundConstraint` instance populated with a predefined list of `AsyncConstraints`
    
    - parameter constraints: `[AsyncConstraint]`
    */
    public static func or<C: AsyncConstraint>(subconstraints: [C]) -> OrAsyncConstraint<T> where C.InputType == T {
        return OrAsyncConstraint(constraints: subconstraints)
    }
    
    /**
    Create a new `AsyncAndCompoundConstraint` instance populated with a unsized list of `AsyncConstraints`
    
    - parameter constraints: `[AsyncConstraint]`
    */
    public static func or<C: AsyncConstraint>(subconstraints: C...) -> OrAsyncConstraint<T> where C.InputType == T {
        return OrAsyncConstraint(constraints: subconstraints)
    }
}
