import Foundation

public struct CompoundAsyncConstraint<T>: AsyncConstraint {
    
    public typealias InputType = T
    
    private init() { }
    
    public func evaluate(with input: T, queue: DispatchQueue, completionHandler: @escaping (ValidationResult) -> Void) {
        fatalError()
    }
}

extension CompoundAsyncConstraint {
    
    /**
     Create a new `AsyncAndCompoundConstraint` instance populated with a predefined list of `AsyncConstraints`
     
     - parameter constraints: `[AsyncConstraint]`
     */
    public static func and<C: AsyncConstraint>(subconstraints: [C]) -> AsyncAndCompoundConstraint<T> where C.InputType == T {
        return AsyncAndCompoundConstraint(constraints: subconstraints)
    }
    
    /**
     Create a new `AsyncAndCompoundConstraint` instance populated with a unsized list of `AsyncConstraints`
     
     - parameter constraints: `[AsyncConstraint]`
     */
    public static func and<C: AsyncConstraint>(subconstraints: C...) -> AsyncAndCompoundConstraint<T> where C.InputType == T {
        return AsyncAndCompoundConstraint(constraints: subconstraints)
    }
}

extension CompoundAsyncConstraint {
    
    /**
    Create a new `AsyncAndCompoundConstraint` instance populated with a predefined list of `AsyncConstraints`
    
    - parameter constraints: `[AsyncConstraint]`
    */
    public static func or<C: AsyncConstraint>(subconstraints: [C]) -> AsyncOrCompoundConstraint<T> where C.InputType == T {
        return AsyncOrCompoundConstraint(constraints: subconstraints)
    }
    
    /**
    Create a new `AsyncAndCompoundConstraint` instance populated with a unsized list of `AsyncConstraints`
    
    - parameter constraints: `[AsyncConstraint]`
    */
    public static func or<C: AsyncConstraint>(subconstraints: C...) -> AsyncOrCompoundConstraint<T> where C.InputType == T {
        return AsyncOrCompoundConstraint(constraints: subconstraints)
    }
}
