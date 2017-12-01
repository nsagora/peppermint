import Foundation

public struct AnyAsyncConstraint<T>:AsyncConstraint {

    private let _evaluate:(T, DispatchQueue, @escaping (Result) -> Void) -> Void
    public typealias InputType = T

    public init<C:AsyncConstraint>(_ constraint:C) where C.InputType == T {
        _evaluate = constraint.evaluate
    }

    public func evaluate(with input: T, queue: DispatchQueue, completionHandler: @escaping (_ result:Result) -> Void) {
        return _evaluate(input, queue, completionHandler)
    }
}

extension AsyncConstraint {

    internal func erase() -> AnyAsyncConstraint<InputType> {
        return AnyAsyncConstraint(self)
    }
}
