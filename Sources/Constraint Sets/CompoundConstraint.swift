import Foundation

public struct CompoundContraint<T>: Constraint {
    
    public typealias InputType = T
    
    private init() { }
    
    public func evaluate(with input: T) -> ValidationResult { fatalError() }
}

extension CompoundContraint {
    
    public static func andConstraintWith<C: Constraint>(subconstraints: [C]) -> AndCompoundConstraint<T> where C.InputType == T {
        return AndCompoundConstraint(constraints: subconstraints)
    }
    
    public static func andConstraintWith<C: Constraint>(subconstraints: C...) -> AndCompoundConstraint<T> where C.InputType == T {
        return AndCompoundConstraint(constraints: subconstraints)
    }
}

extension CompoundContraint {
    
    public static func orConstraintWith<C: Constraint>(subconstraints: [C]) -> OrCompoundConstraint<T> where C.InputType == T {
        return OrCompoundConstraint(constraints: subconstraints)
    }
    
    public static func orConstraintWith<C: Constraint>(subconstraints: C...) -> OrCompoundConstraint<T> where C.InputType == T {
        return OrCompoundConstraint(constraints: subconstraints)
    }
}
