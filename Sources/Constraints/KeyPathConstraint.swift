import Foundation

public struct KeyPathConstraint<T, V>: Constraint {
    
    public typealias InputType = T
    
    private let constraint: AnyConstraint<V>
    private let keyPath: KeyPath<T, V>
    
    public init<C: Constraint>(_ constraint: C, for keyPath: KeyPath<T, V>) where C.InputType == V {
        self.constraint = constraint.erase()
        self.keyPath = keyPath
    }
    
    public func evaluate(with input: InputType) -> Result {
        let value = input[keyPath: keyPath]
        return constraint.evaluate(with: value)
    }
}
