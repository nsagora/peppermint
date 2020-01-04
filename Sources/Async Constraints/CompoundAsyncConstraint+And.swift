import Foundation

extension CompoundAsyncConstraint {
    /**
     A generic collection of `AsyncConstraints` on which an input can be validated on.
     */
    public struct AndAsyncConstraint<T>: AsyncConstraint {
        
        public typealias InputType = T
        
        var constraints: [AnyAsyncConstraint<T>]
        
        /**
         Returns the number of constraints in collection
         */
        var count: Int { constraints.count }
        
        
        init<C: AsyncConstraint>(constraints: [C]) where C.InputType == T {
            self.constraints = constraints.map{ $0.erase() }
        }
        
        /**
         Asynchronous evaluates the input on all `AsyncConstraint`s in the collection.
         
         - parameter input: The input to be validated.
         - parameter queue: The queue on which the completion handler is executed.
         - parameter completionHandler: The completion handler to call when the evaluation is complete. It takes a `Array<Result>` parameter:
         - parameter result: An array of `Result` elements, indicating the evaluation result of each `AsyncConstraint` in collection.
         
         */
        public func evaluate(with input: T, queue: DispatchQueue = .main, completionHandler: @escaping (_ result: Result) -> Void) {
            
            let operationQueue = OperationQueue()
            operationQueue.isSuspended = true;
            
            let operations = constraints.map { AsyncOperation(input: input, constraint: $0) }
            let completionOperation = BlockOperation {
                
                let results = operations.filter { $0.isFinished }.compactMap{ $0.result }
                let summary = Result.Summary(evaluationResults: results)
                queue.async {
                    completionHandler(Result(summary: summary))
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
