import Foundation

public struct CompoundContraint<T>: Constraint {
    
    public typealias InputType = T
    
    private init() { }
    
    public func evaluate(with input: T) -> Result {
        fatalError()
    }
}

extension CompoundContraint {
    
    /**
    Create a new `AndCompoundConstraint` instance populated with a predefined list of `Constraints`
    
    - parameter constraints: `[Constraint]`
    */
    public static func and<C: Constraint>(subconstraints: [C]) -> AndConstraint<T> where C.InputType == T {
        return AndConstraint(constraints: subconstraints)
    }
    
    /**
    Create a new `AndCompoundConstraint` instance populated with a predefined list of `Constraints`
    
    - parameter constraints: `[Constraint]`
    */
    public static func and<C: Constraint>(subconstraints: C...) -> AndConstraint<T> where C.InputType == T {
        return AndConstraint(constraints: subconstraints)
    }
}

extension CompoundContraint {
    
    /**
    Create a new `OrConstraint` instance populated with a predefined list of `Constraints`
    
    - parameter constraints: `[Constraint]`
    */
    public static func or<C: Constraint>(subconstraints: [C]) -> OrConstraint<T> where C.InputType == T {
        return OrConstraint(constraints: subconstraints)
    }
    
    /**
    Create a new `OrConstraint` instance populated with a predefined list of `Constraints`
    
    - parameter constraints: `[Constraint]`
    */
    public static func or<C: Constraint>(subconstraints: C...) -> OrConstraint<T> where C.InputType == T {
        return OrConstraint(constraints: subconstraints)
    }
}
