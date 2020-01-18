import Foundation

extension CompoundAsyncConstraint {
    
    internal struct AndStrategy: AsyncStrategy {
        func evaluate<C>(constraints: [C], with input: C.InputType, queue: DispatchQueue, completionHandler: @escaping (Result) -> Void) where C : AsyncConstraint {
            let operationQueue = OperationQueue()
            operationQueue.isSuspended = true;
            
            let operations = constraints.map { AsyncOperation(input: input, constraint: $0.erase()) }
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
