import Foundation

public struct TypeConstraint<T>: Constraint {

    private var constraints = [AnyConstraint<T>]()

    /**
     Create a new `CollectionConstraint` instance
     */
    public init() {}

    /**
     Set a `Constraint` on a property from the root object.

     - parameter constraint: A `Constraint` on the property at the provided `KeyPath`.
     - parameter keyPath: The `KeyPath` for the property we set the `Constraint` on.
     */
    public mutating func set<C: Constraint, V>(_ constraint: C, for keyPath: KeyPath<T, V>) where C.InputType == V {
        let constraint = KeyPathConstraint(constraint, for: keyPath).erase()
        constraints.append(constraint)
    }

    /**
     Evaluates the input on the set key path`Constraint`s.

     - parameter input: The input to be validated.
     - returns: `.success` if the input is valid,`.failure` containing the `Summary` of the failing `Constraint`s otherwise.
     */
    public func evaluate(with input: T) -> Result {
        let results = constraints.map { $0.evaluate(with: input) }
        return Result(summary: .init(evaluationResults: results))
    }
}
