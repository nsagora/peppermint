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
    public static func andConstraintWith<C: Constraint>(subconstraints: [C]) -> AndCompoundConstraint<T> where C.InputType == T {
        return AndCompoundConstraint(constraints: subconstraints)
    }
    
    /**
    Create a new `AndCompoundConstraint` instance populated with a predefined list of `Constraints`
    
    - parameter constraints: `[Constraint]`
    */
    public static func andConstraintWith<C: Constraint>(subconstraints: C...) -> AndCompoundConstraint<T> where C.InputType == T {
        return AndCompoundConstraint(constraints: subconstraints)
    }
}

extension CompoundContraint {
    
    /**
    Create a new `OrCompoundConstraint` instance populated with a predefined list of `Constraints`
    
    - parameter constraints: `[Constraint]`
    */
    public static func orConstraintWith<C: Constraint>(subconstraints: [C]) -> OrCompoundConstraint<T> where C.InputType == T {
        return OrCompoundConstraint(constraints: subconstraints)
    }
    
    /**
    Create a new `OrCompoundConstraint` instance populated with a predefined list of `Constraints`
    
    - parameter constraints: `[Constraint]`
    */
    public static func orConstraintWith<C: Constraint>(subconstraints: C...) -> OrCompoundConstraint<T> where C.InputType == T {
        return OrCompoundConstraint(constraints: subconstraints)
    }
}
