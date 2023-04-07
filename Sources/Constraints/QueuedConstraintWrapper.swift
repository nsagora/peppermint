import Foundation

public struct QueuedConstraintWrapper<T, E: Error>: QueuedConstraint {
    
    public typealias InputType = T
    public typealias ErrorType = E
    
    private let constraint: any Constraint<T, E>
    private var workQueue: DispatchQueue {
        return DispatchQueue(label: "com.nsagora.peppermint.constraint", attributes: .concurrent)
    }
    
    fileprivate init(constraint: some Constraint<T,E>) {
        self.constraint = constraint
    }
    
    public func evaluate(with input: T, on queue: DispatchQueue, completionHandler: @escaping (Result<Void, Summary<E>>) -> Void) {
        workQueue.async {
            let result = constraint.evaluate(with: input)
            queue.async {
                completionHandler(result)
            }
        }
    }

}

extension Constraint {

    public func queued() -> any QueuedConstraint<Self.InputType, Self.ErrorType> {
        QueuedConstraintWrapper(constraint: self)
    }
}
