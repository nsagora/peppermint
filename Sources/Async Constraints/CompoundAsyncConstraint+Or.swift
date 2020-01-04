import Foundation

extension CompoundAsyncConstraint {
    /**
     A generic collection of `AsyncConstraints` on which an input can be validated on.
     */
    public struct OrAsyncConstraint<T>: AsyncConstraint {
        
        public typealias InputType = T
        
        var constraints: [AnyAsyncConstraint<T>]
        
        /**
         Returns the number of constraints in collection
         */
        public var count: Int { constraints.count }
        
        public init<C: AsyncConstraint>(constraints: [C]) where C.InputType == T {
            self.constraints = constraints.map{ $0.erase() }
        }
        
        /**
         Asynchronous evaluates the input on all `AsyncConstraint`s until the first fails.
         
         - parameter input: The input to be validated.
         - parameter queue: The queue on which the completion handler is executed.
         - parameter completionHandler: The completion handler to call when the evaluation is complete. It takes a `Result` parameter:
         - parameter result: `.success` if the input is valid, `.failure` containing the `Error` registered with the failing `AsyncConstraint` otherwise.
         */
        public func evaluate(with input: T, queue: DispatchQueue = .main, completionHandler: @escaping (_ result: Result) -> Void) {
            
            let operationQueue = OperationQueue()
            operationQueue.isSuspended = true;
            
            let operations = constraints.map { AsyncOperation(input: input, constraint: $0) }
            let completionOperation = BlockOperation {
                let finishedOperations = operations.filter { $0.isFinished }.compactMap{ $0.result }
                let result = finishedOperations.reduce(.success) { $0.isFailed ? $0 : $1 }
                
                queue.async {
                    completionHandler(result)
                }
            }
            
            operationQueue.addOperation(completionOperation)
            for operation in operations {
                completionOperation.addDependency(operation)
                operationQueue.addOperation(operation)
            }
            
            operationQueue.isSuspended = false
        }
    }
}
