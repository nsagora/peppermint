import Foundation

public struct TypeConstraint<T, E: Error>: Constraint {
    
    public typealias InputType = T
    public typealias ErrorType = E

    private var constraints = [AnyConstraint<T, E>]()

    /**
     Create a new `CollectionConstraint` instance
     */
    public init() {}

    /**
     Set a `Constraint` on a property from the root object.

     - parameter constraint: A `Constraint` on the property at the provided `KeyPath`.
     - parameter keyPath: The `KeyPath` for the property we set the `Constraint` on.
     */
    public mutating func set<C: Constraint, V>(for keyPath: KeyPath<T, V>, constraint: C) where C.InputType == V, C.ErrorType == E {
        let constraint = KeyPathConstraint(keyPath, constraints: constraint).erase()
        constraints.append(constraint)
    }
    
    /**
     Set a `Constraint` on a property from the root object.

     - parameter constraint: A `Constraint` on the property at the provided `KeyPath`.
     - parameter keyPath: The `KeyPath` for the property we set the `Constraint` on.
     */
    public mutating func set<C: Constraint, V>(for keyPath: KeyPath<T, V>, constraintBuilder: () -> C ) where C.InputType == V, C.ErrorType == E {
        let constraint = KeyPathConstraint(keyPath, constraints: constraintBuilder()).erase()
        constraints.append(constraint)
    }

    /**
     Evaluates the input on the set key path constraints.

     - parameter input: The input to be validated.
     - returns: `.success` if the input is valid,`.failure` containing the `Summary` of the failing `Constraint`s otherwise.
     */
    public func evaluate(with input: T) -> Result<Void, Summary<E>> {
        return GroupConstraint(constraints: constraints).evaluate(with: input)
    }
}

// MARK: - ConstraintBuilder Extension

extension TypeConstraint {
    
    public init(@ConstraintBuilder<T, E> constraintBuilder: () -> [AnyConstraint<T, E>])  {
        self.constraints = constraintBuilder()
    }
}
