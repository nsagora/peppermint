import Foundation

public struct KeyPathConstraint<T, V, E: Error>: Constraint {
    
    public typealias InputType = T
    public typealias ErrorType = E
    
    private let constraint: CompoundConstraint<V, E>
    private let keyPath: KeyPath<T, V>
    
    public init<C: Constraint>(_ keyPath: KeyPath<T, V>, constraints: [C]) where C.InputType == V, C.ErrorType == E {
        self.constraint = CompoundConstraint(constraints: constraints)
        self.keyPath = keyPath
    }
    
    public init<C: Constraint>(_ keyPath: KeyPath<T, V>, constraints: C...) where C.InputType == V, C.ErrorType == E {
        self.constraint = CompoundConstraint(constraints: constraints)
        self.keyPath = keyPath
    }
    
    public func evaluate(with input: T) -> Result<Void, Summary<E>> {
        let value = input[keyPath: keyPath]
        return constraint.evaluate(with: value)
    }
}

// MARK: - ConstraintBuilder Extension

extension KeyPathConstraint {
    
    public init(_ keyPath: KeyPath<T, V>, @ConstraintBuilder<V, E> constraintBuilder: () -> [AnyConstraint<V, E>])  {
        self.init(keyPath, constraints: constraintBuilder())
    }
}
