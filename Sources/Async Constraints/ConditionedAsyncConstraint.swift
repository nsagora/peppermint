import Foundation

/**
 A structrure that links an `AsyncPredicate` to an `Error` that describes why the predicate evaluation has failed.
 */
public class ConditionedAsyncConstraint<T>: AsyncConstraint {
    
    private var predicate: AnyAsyncPredicate<T>
    private var errorBuilder: (T)->Error
    
    var conditions =  [AnyAsyncConstraint<T>]()
    
    /**
     Create a new `ConditionedAsyncConstraint` instance
     
     - parameter predicate: An `AsyncPredicate` to describes the evaluation rule.
     - parameter error: An `Error` that describes why the evaluation has failed.
     */
    public init<P:AsyncPredicate>(predicate:P, error:Error) where P.InputType == T {
        
        self.predicate = predicate.erase()
        self.errorBuilder = { _ in return error }
    }
    
    /**
     Create a new `ConditionedAsyncConstraint` instance
     
     - parameter predicate: An `AsyncPredicate` to describes the evaluation rule.
     - parameter error: An generic closure that dynamically builds an `Error` to describe why the evaluation has failed.
     */
    public init<P:AsyncPredicate>(predicate:P, error: @escaping (T)->Error) where P.InputType == T {
        
        self.predicate = predicate.erase()
        self.errorBuilder = error
    }

    /**
     Add a condition `AsyncConstraint`.

     - parameter constraint: `Constraint`
     */
    public func add<C:AsyncConstraint>(condition:C) where C.InputType == T {
        conditions.append(condition.erase())
    }
    
    /**
     Asynchronous evaluates the input on the `Predicate`.
     
     - parameter input: The input to be validated.
     - parameter queue: The queue on which the completion handler is executed.
     - parameter completionHandler: The completion handler to call when the evaluation is complete. It takes a `Bool` parameter:
     - parameter result: `.valid` if the input is valid, `.invalid` containing the `Result.Summary` of the failing `Constraint`s otherwise.
     */
    public func evaluate(with input: T, queue: DispatchQueue, completionHandler: @escaping (_ result:Result) -> Void) {
        
        if (!hasConditions()) {
            return continueEvaluate(with: input, queue: queue, completionHandler: completionHandler)
        }
        
        let predicateSet = AsyncConstraintSet(constraints: conditions)
        predicateSet.evaluateAll(input: input, queue: queue) { result in
            
            if result.isValid {
                return self.continueEvaluate(with: input, queue: queue, completionHandler: completionHandler)
            }
            
            completionHandler(result)
        }
    }
    
    private func hasConditions() -> Bool {
        return conditions.count > 0
    }
    
    private func continueEvaluate(with input: T, queue: DispatchQueue, completionHandler: @escaping (_ result:Result) -> Void) {
        
        predicate.evaluate(with: input, queue: queue) { matches in
            
            if matches {
                completionHandler(.valid)
            }
            else {
                let error = self.errorBuilder(input)
                let summary = Result.Summary(errors: [error])
                completionHandler(.invalid(summary))
            }
        }
    }
}
