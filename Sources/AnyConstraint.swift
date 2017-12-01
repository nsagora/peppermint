import Foundation

public struct AnyConstraint<T>:Constraint {

    private let _evaluate:(T) -> Result
    public typealias InputType = T

    public init<C:Constraint>(_ constraint:C) where C.InputType == T {
        _evaluate = constraint.evaluate
    }

    public func evaluate(with input: InputType) -> Result {
        return _evaluate(input)
    }
}

extension Constraint {

    internal func erase() -> AnyConstraint<InputType> {
        return AnyConstraint(self)
    }
}
