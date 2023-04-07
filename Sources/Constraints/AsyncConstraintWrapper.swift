import Foundation

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public struct AsyncConstraintWrapper<T, E: Error>: AsyncConstraint {
    
    public typealias InputType = T
    public typealias ErrorType = E
    
    private let constraint: any Constraint<T, E>
    
    fileprivate init(constraint: some Constraint<T,E>) {
        self.constraint = constraint
    }
    
    public func evaluate(with input: T) async -> Result<Void, Summary<E>> {
        await Task {
            constraint.evaluate(with: input)
        }.value
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Constraint {

    public func `async`() -> any AsyncConstraint<Self.InputType, Self.ErrorType> {
        AsyncConstraintWrapper(constraint: self)
    }
}
