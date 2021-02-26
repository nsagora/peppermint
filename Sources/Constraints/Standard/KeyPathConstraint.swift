import Foundation

public struct KeyPathConstraint<T, V, E: Error>: Constraint {
    
    public typealias InputType = T
    public typealias ErrorType = E
    
    private let constraint: AnyConstraint<V, E>
    private let keyPath: KeyPath<T, V>
    
    public init<C: Constraint>(_ constraint: C, for keyPath: KeyPath<T, V>) where C.InputType == V, C.ErrorType == E {
        self.constraint = constraint.erase()
        self.keyPath = keyPath
    }
    
    public func evaluate(with input: T) -> Result<Void, Summary<E>> {
        let value = input[keyPath: keyPath]
        return constraint.evaluate(with: value)
    }
}
