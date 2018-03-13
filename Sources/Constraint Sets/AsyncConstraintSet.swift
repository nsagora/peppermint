import Foundation

/**
 A generic collection of `AsyncConstraints` on which an input can be validated on.
 */
public struct AsyncConstraintSet<T> {
    
    var constraints: [AnyAsyncConstraint<T>]

    /**
     Returns the number of constraints in collection
     */
    public var count:Int {
        return constraints.count
    }
    
    /**
     Create a new `AsyncConstraintSet` instance 
     */
    public init() {
        self.constraints = [AnyAsyncConstraint<T>]()
    }
    
    /**
     Create a new `AsyncConstraintSet` instance populated with a predefined list of `AsyncConstraints`
     
     - parameter constraints: `[AsyncConstraint]`
     */
    public init<C:AsyncConstraint>(constraints:[C]) where C.InputType == T {
        self.constraints = constraints.map{ $0.erase() }
    }
    
    /**
     Create a new `AsyncConstraintSet` instance populated with a unsized list of `AsyncConstraints`
     
     - parameter constraints: `[AsyncConstraint]`
     */
    public init<C:AsyncConstraint>(constraints:C...) where C.InputType == T {
        self.init(constraints: constraints)
    }
}


extension AsyncConstraintSet {
    
    /**
     Adds a `AsyncConstraint` to the generic collection of constraints.
     
     - parameter constraint: `AsyncConstraint`
     */
    public mutating func add<C:AsyncConstraint>(constraint:C) where C.InputType == T {
        constraints.append(constraint.erase())
    }
    
    
    /**
     Adds a `AsyncConstraint` to the generic collection of constraints.
     
     - parameter predicate: An `AsyncPredicate` to describes the evaluation rule.
     - parameter error: An `Error` to describe the reason why the input is invalid.
     */
    public mutating func add<P:AsyncPredicate>(predicate:P, error:Error) where P.InputType == T {
        let constraint = SimpleAsyncConstraint(predicate: predicate, error: error)
        add(constraint: constraint.erase())
    }
}

extension AsyncConstraintSet {
 
    /**
     Asynchronous evaluates the input on all `AsyncConstraint`s until the first fails.
     
     - parameter input: The input to be validated.
     - parameter queue: The queue on which the completion handler is executed.
     - parameter completionHandler: The completion handler to call when the evaluation is complete. It takes a `Result` parameter:
     - parameter result: `.valid` if the input is valid, `.invalid` containing the `Error` registered with the failing `AsyncConstraint` otherwise.
     */
    public func evaluateAny(input:T, queue: DispatchQueue = .main, completionHandler:@escaping (_ result:Result) -> Void) {
        
        let operationQueue = OperationQueue()
        operationQueue.isSuspended = true;
        
        let operations = constraints.map { AsyncOperation(input: input, constraint: $0) }
        let completionOperation = BlockOperation {
            let finishedOperations = operations.filter { $0.isFinished }.flatMap{ $0.result }
            let result = finishedOperations.reduce(.valid) { $0.isInvalid ? $0 : $1 }
            
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
    
    /**
     Asynchronous evaluates the input on all `AsyncConstraint`s in the collection.
     
     - parameter input: The input to be validated.
     - parameter queue: The queue on which the completion handler is executed.
     - parameter completionHandler: The completion handler to call when the evaluation is complete. It takes a `Array<Result>` parameter:
     - parameter result: An array of `Result` elements, indicating the evaluation result of each `AsyncConstraint` in collection.

     */
    public func evaluateAll(input:T, queue: DispatchQueue = .main, completionHandler:@escaping (_ result:Result) -> Void) {
        
        let operationQueue = OperationQueue()
        operationQueue.isSuspended = true;
        
        let operations = constraints.map { AsyncOperation(input: input, constraint: $0) }
        let completionOperation = BlockOperation {
            
            let results = operations.filter { $0.isFinished }.flatMap{ $0.result }
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
