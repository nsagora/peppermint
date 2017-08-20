import Foundation

/**
 A generic collection of `AsyncConstraints` on which an input can be validated on.
 */
public struct AsyncConstraintSet<T> {
    
    var constraints: [AsyncConstraint<T>]
    
    public var count:Int {
        return constraints.count
    }
    
    /**
     Create a new `AsyncConstraintSet` instance
     */
    public init() {
        self.constraints = [AsyncConstraint<T>]()
    }
    
    /**
     Create a new `AsyncConstraintSet` instance populated with a predefined list of `AsyncConstraints`
     
     - parameter constraints: `[Constraint]`
     */
    public init(constraints:[AsyncConstraint<T>]) {
        self.constraints = constraints
    }
    
    /**
     Create a new `AsyncConstraintSet` instance populated with a unsized list of `AsyncConstraints`
     
     - parameter constraints: `[Constraint]`
     */
    public init(constraints:AsyncConstraint<T>...) {
        self.init(constraints: constraints)
    }
}


extension AsyncConstraintSet {
    
    /**
     Adds a `AsyncConstraint` to the generic collection of constraints.
     
     - parameter constraint: `AsyncConstraint`
     */
    public mutating func add(constraint:AsyncConstraint<T>) {
        constraints.append(constraint)
    }
    
    
    /**
     Adds a `AsyncConstraint` to the generic collection of constraints.
     
     - parameter predicate: An `AsyncPredicate` to describes the evaluation rule.
     - parameter error: An `Error` to describe the reason why the input is invalid.
     */
    public mutating func add<P:AsyncPredicate>(predicate:P, error:Error) where P.InputType == T {
        let constraint = AsyncConstraint(predicate: predicate, error: error)
        add(constraint: constraint)
    }
}

extension AsyncConstraintSet {
 
    /**
     Asynchronous evaluates the input on all `AsyncConstraint`s until the first fails.
     
     - parameter input: The input to be validated.
     - parameter queue: The queue on which the completion handler is executed.
     - parameter completionHandler: The completion handler to call when the evaluation is complete. It takes a `EvaluationResult` parameter:
     - parameter result: `.valid` if the input is valid, `.invalid` containing the `Error` registered with the failing `Constraint` otherwise.
     
     - returns:
     */
    public func evaluateAny(input:T, queue: DispatchQueue = .main, completionHandler:@escaping (_ result:EvaluationResult) -> Void) {
        
        let operationQueue = OperationQueue()
        operationQueue.isSuspended = true;
        
        let operations = constraints.map { AsyncOperation(input: input, constraint: $0) }
        let done = BlockOperation {
            let finishedOperations = operations.filter { $0.isFinished }.map{ $0.result! }
            let result = finishedOperations.reduce(.valid) { $0.isInvalid ? $0 : $1 }
            
            queue.async {
                completionHandler(result)
            }
        }
        
        operationQueue.addOperation(done)
        for operation in operations {
            done.addDependency(operation)
            operationQueue.addOperation(operation)
        }
        
        operationQueue.isSuspended = false
    }
}
